class BookingsController < ApplicationController
  respond_to :html, :xml, :json
  #load_and_authorize_resource
  before_action :find_booking, only: [:edit]
  before_action :find_location, except: [:edit]
  skip_before_action :verify_authenticity_token

  def admin
    @bookings = Booking.all
  end

  def index
    REDIS.set("booking_notifications_"+current_user.id.to_s,"0")
    @bookings=nil
    @bookings=Booking.where("status>0").order("id DESC")
    @user = current_user
    unless current_user.status=="admin"
      @bookings=@bookings.where(:user_id=>current_user.id)
      current_user.locations.each do |location|
        @bookings=@bookings+location.bookings
      end
    end
    respond_to do |format|
      format.html
      format.xml
      format.json {@bookings.to_json}
    end
  end

  def new
    @booking = Booking.new(location_id: params[:id])
    @location = Location.find(params[:id])
  end
  def price
    price=nil
    success=true
    message=nil
    start_date=nil
    end_date=nil
    begin
      start_date=Date.parse(params[:start_date])
    rescue ArgumentError
      success=false
      message="Fecha de inicio es invalida"
    end
    begin
      end_date=Date.parse(params[:end_date])
    rescue ArgumentError
      success=false
      message="Fecha de termino es invalida"
    end
    if start_date && end_date
      @booking= Booking.new(:start_time=>start_date.to_time.beginning_of_day,:end_time=>end_date.to_time.end_of_day,:location=>Location.find(params[:location_id]))
      @booking.updateprice
      price=@booking.price
    end
    render :json=>{:success=>success,:price=>price,:message=>message}
  end
  def accept
    @booking=Booking.find_by_code(params[:code])
    @booking.accept
    UserMailer.booking_accepted(@booking).deliver
    UserMailer.admin_booking_accepted(@booking).deliver
    REDIS.lpush("booking#{@booking.code}",{:datetime=>Time.now.to_i,:text=>"Reserva aceptada por "+@booking.location.user.full_name,:action=>"accepted"}.to_json)
    redirect_to "/bookings", :notice=>"Reserva aceptada"
  end
  def cancel
    @booking=Booking.find_by_code(params[:code])
    @booking.destroy
    REDIS.lpush("booking#{@booking.code}",{:datetime=>Time.now.to_i,:text=>"Reserva cancelada por #{current_user.full_name}",:action=>"cancelled"}.to_json)
    UserMailer.booking_cancelled(@booking).deliver
    redirect_to "/bookings", :notice=>"Reserva cancelada"
  end
  def delete
    @booking=Booking.find_by_code(params[:code])
    @booking.destroy
    REDIS.lpush("booking#{@booking.code}",{:datetime=>Time.now.to_i,:text=>"Reserva borrada por #{current_user.full_name}",:action=>"cancelled"}.to_json)
    UserMailer.booking_cancelled(@booking).deliver
    redirect_to "/bookings", :notice=>"Reserva eliminada"
  end
  def create
    @success=false
    # check dates are valid
      @start_time=DateTime.parse(params[:start_date].to_s).beginning_of_day
      @end_time=DateTime.parse(params[:end_date].to_s).end_of_day
      @location=Location.find(params[:location_id])
      # checks start date < end date
      if(@start_time<@end_time)
        @booking=current_user.book(@location,@start_time,@end_time)
        @success=true if @booking
      else
        @message="La fecha de inicio debe ser antes de la fecha de término"
      end
    if @success==true
      UserMailer.booking_requested(@booking).deliver
      UserMailer.booking_sent(@booking).deliver
      comment={:datetime=>Time.now.to_i,:text=>params[:comment],:user=>{:full_name=>current_user.full_name},:action=>"comment"}
      REDIS.lpush("booking#{@booking.code}",comment.to_json) if params[:comment] && params[:comment].length>0
      @booking.location.user.notify("booking")
      @booking.user.notify("booking")

      flash[:notice] = "Tu solicitud de reserva fue enviada. Por favor espera durante las próximas horas hasta que sea revisada por el administrador de la locación."
      redirect_to "/"
    else
      redirect_to "/", flash: {error: "Hubo un error confirmando el pago."}
    end
  end

  def show
    @booking = Booking.find_by_code(params[:code])
    @history=[]
    if(REDIS.lrange("booking#{@booking.code}",0,-1))
      REDIS.lrange("booking#{@booking.code}",0,-1).each do |json|
        @history.push(JSON.parse(json))
      end
    end
  end



  def edit
    #@booking = Booking.find_by_code(params[:id])
  end

  def update
    @booking = Booking.find_by_code(params[:id])
    # @booking.locations = @locations

    if @booking.update(params[:booking].permit(:location_id, :start_time, :end_time))
      flash[:notice] = 'Your booking was updated succesfully'

      if request.xhr?
        render json: {status: :success}.to_json
      else
        redirect_to location_bookings_path(@location)
      end
    else
      render 'edit'
    end
  end
  def comment
    @booking=Booking.find_by_code(params[:code])
    if params[:body] && params[:body].length>0
      comment={:datetime=>Time.now.to_i,:text=>params[:body],:user=>{:full_name=>current_user.full_name},:action=>"comment"}
      REDIS.lpush("booking#{@booking.code}",comment.to_json)
      #if owner of the booking is current_user send email to location owner
      if @booking.user==current_user
        UserMailer.booking_commented(@booking,@booking.location.user,comment[:text]).deliver
      end
      if @booking.location.user==current_user
        UserMailer.booking_commented(@booking,@booking.user,comment[:text]).deliver
      end
      render :json=>{:success=>true,:comment=>comment}
    else
      render :json=>{:success=>false}
    end

  end
  def confirmpayment

    @booking=Booking.find_by_code(params[:code])
    if @booking.confirm_payment
      UserMailer.payment_confirmed(@booking).deliver
      REDIS.lpush("booking#{@booking.code}",{:datetime=>Time.now.to_i,:text=>"Pago confirmado",:action=>"payment"}.to_json)
      @booking.user.notify("booking")
      @booking.location.user.notify("booking")

      redirect_to "/bookings", flash: {notice: "El pago de la reserva ##{@booking.code} ha sido confirmado."}
    else
      redirect_to "/bookings", flash: {notice: "Hubo un error confirmando el pago."}
    end
  end

  private

  def save booking
    if @booking.save
        flash[:notice] = 'booking added'
        redirect_to location_booking_path(@location, @booking)
      else
        render 'new'
      end
  end

  def find_booking
    @booking = Booking.find_by_id(params[:id].to_i)
    @location = @booking.location
  end

  def find_location
    if params[:location_id]
      @location = Location.find_by_id(params[:location_id])
    end
  end

end

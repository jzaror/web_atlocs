class BookingsController < ApplicationController
  respond_to :html, :xml, :json
  load_and_authorize_resource
  before_action :find_booking, only: [:edit]
  before_action :find_location, except: [:edit]
  skip_before_action :verify_authenticity_token

  def admin
    @bookings = Booking.all
    REDIS.set("booking_notifications_"+current_user.id.to_s,"0")
  end

  def index
    REDIS.set("booking_notifications_"+current_user.id.to_s,"0")
    @bookings=nil
    @bookings=Booking.where("status>0").order("id DESC")
    @any_accepted = @bookings.select{|b| b.status == "accepted"}.length > 0
    @any_not_waiting = @bookings.select{|b| b.status != "waiting"}.length > 0

    @user = current_user
    unless current_user.status=="admin"
      @bookings=@bookings.where(:user_id=>current_user.id)
      current_user.locations.each do |location|
        @bookings=@bookings+location.bookings.select{|booking| booking.status != 'archived'}
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
    rescue => e
      success=false
      message="Fecha de inicio es invalida"
    end
    begin
      end_date=Date.parse(params[:end_date])
    rescue => e
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
    AdminMailer.admin_booking_accepted(@booking).deliver
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

  def cancel_booking
    @booking= Booking.find_by(id: params[:id])
    @user = User.find_by(id: params[:user_id])
    @booking.archive
    if @booking.user.id == @user.id
      UserMailer.client_booking_cancel(@booking, params[:reject_reason]).deliver_now
      UserMailer.owner_booking_cancel(@booking, params[:reject_reason]).deliver_now
      AdminMailer.admin_booking_cancel(@booking, params[:reject_reason]).deliver_now
    else
      UserMailer.client_booking_cancel_by_owner(@booking, params[:reject_reason]).deliver_now
      UserMailer.owner_booking_cancel_by_owner(@booking, params[:reject_reason]).deliver_now
      AdminMailer.admin_booking_cancel_by_owner(@booking, params[:reject_reason]).deliver_now
    end
    REDIS.lpush("booking#{@booking.code}",{:datetime=>Time.now.to_i,:text=>"Reserva cancelada por #{current_user.full_name}",:action=>"cancelled"}.to_json)
    redirect_to bookings_path
  end

  def delete
    @booking=Booking.find_by_code(params[:code])
    @booking.destroy
    REDIS.lpush("booking#{@booking.code}",{:datetime=>Time.now.to_i,:text=>"Reserva borrada por #{current_user.full_name}",:action=>"cancelled"}.to_json)
    UserMailer.booking_cancelled(@booking).deliver
    redirect_to "/bookings", :notice=>"Reserva eliminada"
  end

  def destroy
    if @booking.destroy
      respond_to do |format|
        format.html do
          redirect_to "/admin/bookings", :notice=>"Reserva eliminada"
        end
      end
    end
  end

  def create
    @success=false
    # check dates are valid
      @start_time=DateTime.parse(params[:start_date].to_s).beginning_of_day
      @end_time=DateTime.parse(params[:end_date].to_s).end_of_day
      @location=Location.find(params[:location_id])
      # checks start date < end date
      if(@start_time<@end_time)
        if @location.has_date_range_available?(@end_time,@start_time)
          @booking=current_user.book(@location,@start_time,@end_time)
          @success=true if @booking
        else
          @message = "Lo sentimos. La locación ya está reservada para ese rango de fechas"
        end
      else
        @message="La fecha de inicio debe ser antes de la fecha de término"
      end
    if @success==true
      UserMailer.booking_requested(@booking).deliver_now
      UserMailer.booking_sent(@booking).deliver_now
      AdminMailer.admin_booking_created(@booking).deliver_now
      comment={:datetime=>Time.now.to_i,:text=>params[:comment],:user=>{:full_name=>current_user.full_name},:action=>"comment"}
      REDIS.lpush("booking#{@booking.code}",comment.to_json) if params[:comment] && params[:comment].length>0
      User.where(status: 5).each do |admin|
        admin.notify('booking')
      end
      @booking.location.user.notify("booking")
      @booking.user.notify("booking")

      flash[:notice] = "Tu solicitud de reserva fue enviada. Por favor espera durante las próximas horas hasta que sea revisada por el administrador de la locación."
      redirect_to bookings_path
    else
      redirect_to "/", flash: {notice: @message}
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
    @booking = Booking.find_by(id: params[:id])
  end

  def update
    @booking = Booking.find_by(id: params[:id])
    old_start = l(@booking.start_time, format: '%d/%m/%Y')
    old_end = l(@booking.end_time, format: '%d/%m/%Y')
    start_time = params[:start_date].to_datetime
    end_time = params[:end_date].to_datetime
    if @booking.update(start_time: start_time, end_time: end_time)
      @booking.updateprice
      if @booking.status == 'accepted'
        @booking.update(status: 'waiting')
      end
      UserMailer.booking_edit(@booking).deliver_now
      UserMailer.booking_edit_request(@booking, old_start, old_end).deliver_now
      @booking.save
      flash[:notice] = 'Tu reserva fue actualizada con éxito'
      if request.xhr?
        render json: {status: :success}.to_json
      else
        redirect_to bookings_path
      end
    else
      render bookings_path
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
      UserMailer.payment_confirmed_owner(@booking).deliver
      AdminMailer.payment_confirmed_admin(@booking).deliver
      REDIS.lpush("booking#{@booking.code}",{:datetime=>Time.now.to_i,:text=>"Pago confirmado",:action=>"payment"}.to_json)
      @booking.user.notify("booking")
      @booking.location.user.notify("booking")

      redirect_to "/bookings", flash: {notice: "El pago de la reserva ##{@booking.code} ha sido confirmado."}
    else
      redirect_to "/bookings", flash: {notice: "Hubo un error confirmando el pago."}
    end
  end

  def cancel_modal
    @booking = Booking.find_by(id: params[:id])
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

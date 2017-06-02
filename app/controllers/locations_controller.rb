class LocationsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:frontpage, :feature_image]
  autocomplete :tag, :name
  before_action :set_location, only: [:show, :edit, :update, :destroy, :archive, :approve, :front_page, :delete_request]
  load_and_authorize_resource

  # GET /locations
  def index
    if params[:s]
      @locations=Location.where(:status=>3).custom_search(params[:s]).order(created_at: :desc)
    elsif params[:collection]
      @locations = Location.where(:status=>3).where(:collection_id=>params[:collection]).order(created_at: :desc)
    else
      @locations = Location.where(:status=>3).order(created_at: :desc)
    end
  end

  def admin
    REDIS.set("location_notifications_"+current_user.id.to_s,"0")
    @approved=Location.approved.order("created_at DESC")
    @submitted=Location.submitted.order("created_at DESC")
    @drafts=Location.draft.order("created_at DESC")
    @archived=Location.archived.order("created_at DESC")
    unless current_user.status=="admin"
      @approved=@approved.where(:user_id=>current_user.id)
      @submitted=@submitted.where(:user_id=>current_user.id)
      @drafts=@drafts.where(:user_id=>current_user.id)
    end
    @totalcount=@approved.count
  end

  # GET /locations/1
  def show
    #if @location.status == "approved" || (current_user&&current_user.status=="admin") || @location.user == current_user
      case @location.status
      when "submitted"
        flash.now[:notice] = "Esta locación está esperando aprobación y en algunas horas mas será publicada."
      when "archived"
        flash.now[:error] = "Tu locación no ha sido aprobada debido a los siguientes problemas: "
      end
      user=current_user
      respond_to :html
    #else
    #  if current_user != nil
    #    redirect_to root_path, flash: {notice: "Esta locación aún no ha sido aprobada"}
    #  else
    #    redirect_to "/login", flash: {notice: "Para entrar a esta sección debes iniciar sesión"}
    #  end
    #end
  end

  def frontpage
    @location = Location.find(params[:id])

    if @location.update_attributes(:front_page => params[:front_page])
      # ... update successful
      render :text => "YES"
    else
      # ... update failed
      render :text => "NO"
    end
  end

  # GET /locations/new
  def new
      @location = Location.new
      @location.user_id=current_user.id
      @location.save
      redirect_to edit_location_path(@location, :newlocation=>true)
  end

  # GET /locations/1/edit
  def edit
  end

  def show_archive_modal
  end

  def re_send_reject_email
    if @location.user
      UserMailer.location_problem(@location).deliver
    end
  end

  def create
    @location = current_user.locations.new(location_params)

    @location.user_id=current_user.id
    respond_to do |format|
      if @location.update(location_params) || @location.save
        if params[:images]
          #===== The magic is here ;)
          params[:images].each do |image|
            @location.uploads.create(image: image)
          end
        end
        UserMailer.location_submitted(@location).deliver
        @location.update_attribute("status",2)
        format.html { redirect_to(location_path(@location, :open=>@modal), :notice => 'La locación fue creada con exito.') }
        format.js
      else
        format.html { render :action => "new" }
        format.js
      end
    end
  end

  # PATCH/PUT /locations/1
  def update
    if @location.update(location_params)
      @location.submit
      if @location.status == "submitted"
        LocationMailer.new_location(@location).deliver
        UserMailer.location_submitted(@location).deliver
      end
      if params[:images]
        #===== The magic is here ;)
        params[:images].each do |image|
          @location.uploads.create(image: image)
        end
      end
      if params[:newlocation]
        redirect_to "/nueva_locacion"
      else
        redirect_to @location
      end
    else
      render :edit
    end
  end

  def approve
    @location.approve
    @location.user.notify("location")
    UserMailer.location_approved(@location).deliver
    redirect_to "/admin/locations", notice: "La locación #{@location.title} fue aprobada con exito."
  end

  def archive
    @location.archive
    @location.update_attribute(:reject_reason, params[:reject_reason])
    if @location.user
      UserMailer.location_problem(@location).deliver
    end
    redirect_to '/admin/locations', notice: "La locación #{@location.title} fue archivada con exito."
  end

  def destroy
    if @location.destroy
      redirect_to '/admin/locations', notice: "La locación #{@location.title} fue destruida con exito."
    end
  end

  def feature_image
    @location.update_attribute(:main_attachment_id,params[:attachment_id])
    respond_to do |format|
      format.json { render json: @location, status: :ok }
    end
  end

  def request_removal
    @location = Location.find_by(id: params[:id])
  end

  def delete_request
    UserMailer.request_location_removal_admin(@location, params[:reject_reason]).deliver_now
    UserMailer.request_location_removal_owner(@location, params[:reject_reason]).deliver_now
    redirect_to "/users/#{@location.user.id}", flash: {notice: "Se ha notificado al administrador para eliminar la locación #{@location.title}"}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_location
      @location = Location.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def location_params
      #params[:location][:tag_names] ||= []
      #, { :tag_names=>[] }
      params.require(:location).permit(:title, :days, :city, :type_id, :price, :fee, :description, :address, :lat, :lng, :county, :collection_id, :front_page, :upload, :tag_names, { :uploads_attributes=>[ :_destroy, :id, :image ] }, { :services=>[] }, { :extras=>[] })
    end
end

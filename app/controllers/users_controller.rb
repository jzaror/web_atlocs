class UsersController < ApplicationController
	load_and_authorize_resource :except => [:set_locale]
	skip_before_action :verify_authenticity_token

	def admin
		@users=User.all.order(id: :DESC)
	end

	def create
		@user = User.with_deleted.find_by(email: params[:user][:email])
		if @user
			@user.recover
			if @user.update(user_params)
				flash[:notice]="Gracias por reactivar tu cuenta en Atlocs! Ya puedes publicar o reservar locaciones!"
				session[:user_id] = @user.id
				#SessionMailer.confirmation_instructions(@user, @user.confirmation_token).deliver_now
				#UserMailer.confirmation(@user).deliver_now
				#UserMailer.welcome(user).deliver
				if session[:url_after_session]
					url=session[:url_after_session]
					session[:url_after_session]=nil
					redirect_to url
				else
					redirect_to root_path
				end
			else
				respond_to do |format|
					format.html {render :new}
					format.json {render json: @user.errors, success: false, message: @user.errors.full_messages.to_sentence}
				end
			end
		else
			@user=User.new(user_params)
			if @user.save
				flash[:notice]="Te has registrado en Atlocs! Te hemos enviado un email para confirmar tu registro"
				redirect_to root_path
			else
				respond_to do |format|
					format.html {render :new}
					format.json {render json: @user.errors, success: false, message: @user.errors.full_messages.to_sentence}
				end
			end
		end
	end

	def show
		if params[:id]
			@user=User.find(params[:id])
			REDIS.set("location_notifications_"+@user.id.to_s,"0") if @user == current_user
		else
			@user=current_user
		end
	end

	def edit
		@user=current_user
	end

	def update
		@user = current_user
		if @user.update_attributes(user_params)
			redirect_to "/users/#{@user.id}", :flash => :success
		else
			redirect_to "/users/edit", :flash => :error
		end
	end

	def bookings
		@user=current_user
		@bookings=@user.bookings.all
	end

	def request_delete
		@user = User.find_by(id: params[:id])
	end

	def request_annulation
		@user = User.find(params[:id])
		AdminMailer.request_destroy_admin(@user, params[:reject_reason]).deliver
		UserMailer.request_destroy(@user).deliver
		flash[:notice] = "Solicitud enviada"
		redirect_to @user
	end

	def destroy
		@user.destroy
		flash[:notice]="Usuario eliminado"
		redirect_to "/admin/users/"
	end

	private
	# Use callbacks to share common setup or constraints between actions.
	def set_user
	  @user = User.find(params[:id])
	end

	# Only allow a trusted parameter "white list" through.
	def user_params
		params.require(:user).permit(:first_name, :last_name, :email, :phone,
																 :password, :deposit_bank, :deposit_account,
																 :password_confirmation, :owning, :tenant)
	end
end

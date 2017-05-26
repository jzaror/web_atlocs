class UsersController < ApplicationController
	load_and_authorize_resource
	skip_before_action :verify_authenticity_token

	def admin
		@users=User.all.order(id: :DESC)
	end

	def create
		user=User.new(user_params)

		if params[:phone].to_i>999999999
			render :json=>{:success=>false,:message=>"Teléfono inválido"}
		elsif user.save
			flash[:notice]="Te has registrado en Atlocs! Ya puedes publicar o reservar locaciones!"
			session[:user_id] = user.id
			UserMailer.confirmation(user).deliver
			#UserMailer.welcome(user).deliver
			if session[:url_after_session]
				url=session[:url_after_session]
				session[:url_after_session]=nil
				redirect_to url
			else
				redirect_to root_path
			end
		else
			render :edit, :json=>{:success=>false,:message=>user.errors.full_messages.to_sentence}
		end
	end

	def show
		if params[:id]
			@user=User.find(params[:id])
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

	def destroy
		@user.destroy
		redirect_to "/admin/users/"
		flash[:notice]="Usuario eliminado"
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
																 :password_confirmation, :owner, :tenant)
	end
end

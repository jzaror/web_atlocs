class SessionsController < ApplicationController
	#layout "sessions"
	skip_before_action :verify_authenticity_token
	def new

	end
	def create
		user = User.find_by_email(params[:email])
		# If the user exists AND the password entered is correct.

		if user && user.authenticate(params[:password]) && user.active_for_authentication?
			# Save the user id inside the browser cookie. This is how we keep the user
			# logged in when they navigate around our website.
			session[:user_id] = user.id
			user.sign_in_count=0 if(user.sign_in_count==nil)
			user.sign_in_count=user.sign_in_count+1;
			user.save
			respond_to do |format|
			  format.html {
				if session[:requestUri]!=nil
					#flash[:notice] = "Bienvenido"
					redirect_to session[:requestUri]
					session.delete(:requestUri)
				else
					#flash[:notice] = "Bienvenido"
					if session[:url_after_session]
						url=session[:url_after_session]
						session[:url_after_session]=nil
						redirect_to url
					else
						redirect_to root_path
					end
				end
			  }
			  format.json {
				render json: {:success=>true,:current_user=>{id:user.id,first_name:user.first_name,:current_user=>{:id=>current_user.id,:first_name=>current_user.first_name}}}
			  }
			end
		else
			if user && !user.active_for_authentication?
				message="Cuenta no confirmada aún"
			else
				message="E-mail o contraseña incorrectos"
			end
			respond_to do |format|
				format.html {
					flash[:notice] = message
					redirect_to "/login"
				}
				format.json { render json: {:success=>false,:message=>message} }
			end
		end
	end
	def destroy
		session[:user_id] = nil
		redirect_to "/"
	end
	def requestpasswordupdate
		if params[:email]
			if @user=User.find_by_email(params[:email])
				if(@user.update_attribute(:reset_password_token,SecureRandom.hex[0..8])==false)
					render :text=>"Error"
				end
				UserMailer.request_password_token(@user, @user.reset_password_token,params[:email]).deliver
			end
		end
	end
	def updatepassword
		@user=User.where(:reset_password_token=>params[:code]).first
		if(params[:password] && params[:password_confirmation])
			@user.password=params[:password]
			@user.password_confirmation=params[:password_confirmation]
			if @user.save
				UserMailer.password_changed(@user).deliver_now
				redirect_to "/login", flash:{:notice=>"Tu password fue actualizado"}
			else
				render :text=>"Error"
			end
		end
	end

	def create_user
		if @user.save
			session[:user_id] = user.id
			UserMailer.welcome(user).deliver
			if session[:requestUri]!=nil
				redirect_to session[:requestUri]
				session.delete(:requestUri)
			else
				redirect_to "/"
			end
		else
			respond_to do |format|
				format.html { redirect_to "/signup", flash: {:notice =>@user.errors.full_messages.to_sentence} }
				format.json { render :json=>{:success=>false,:message=>@user.errors.full_messages.to_sentence} }
			end

		end
	end

	def register
		@user = User.new
	end

	private

	def user_params
	  params.permit(:first_name, :last_name, :email, :phone, :password,
									:deposit_bank, :deposit_account, :password_confirmation,
									:owning, :tenant)
	end

end

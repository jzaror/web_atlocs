class UserMailer < ActionMailer::Base
	default from: "AtLocs <contacto@atlocs.com>"
	layout 'mailer'

	def welcome(user)
		@user = user
		mail(to: @user.email, subject: '¡Bienvenid@ a AtLocs!')
	end

	def confirmation(user)
		@user = user
		mail(to: @user.email, subject: '¡Bienvenid@ a AtLocs!')
	end

	def location_submitted(location)
		@user = location.user
		@location = location
		mail(to: @user.email, subject: 'Tu locación ha sido recibida')
	end

	def location_approved(location)
		@user = location.user
		@location = location
		mail(to: @user.email, subject: '¡Tu locación ha sido aprobada!')
	end

	def location_problem(location)
		@user = location.user
		@location = location
		mail(to: @user.email, subject: 'Tu locación necesita algunos cambios para nuestra aprobación')
	end

	def request_location_removal(location,user)
		@location = location
		@user = user
		mail(to: Conf.value('admin_email'),subject: "Solicitud eliminación de locación #{@location.title}")
	end

	def booking_requested(booking)
		@user = booking.location.user
		@location = booking.location
		@booking=booking
		mail(to: @user.email, subject: '¡Tienes una solicitud de reserva para tu locación!')
	end

	def booking_sent(booking)
		@user = booking.user
		@location = booking.location
		@booking=booking
		mail(to: @user.email, subject: 'Has solicitado una reserva en AtLocs.')
	end

	def booking_accepted(booking)
		@user = booking.user
		@location = booking.location
		@booking=booking
		mail(to: @user.email, subject: '¡Han aprobado tu Reserva!')
	end

	def booking_cancelled(booking)
		@user = booking.user
		@location = booking.location
		@booking=booking
		mail(to: @user.email, subject: 'Tu reserva ha sido cancelada')
	end

	def booking_commented(booking,sender)
		@user=sender
		@booking=booking
		mail(to: @user.email, subject: 'Tienes un mensaje en tu reserva')
	end

	def payment_confirmed(booking)
		@booking = booking
		@user = @booking.user
		mail(to: @user.email, subject: '¡Ya tienes una reserva lista en AtLocs!')
	end

	def contact_form(email,body,subject)
		@body=body
		mail(to: Conf.value('admin_email'),subject: subject, from:email)
	end

	def request_password_token(code,email)
		@code=code
		mail(to: email, subject: '¿Olvidaste tu contraseña?')
	end

	def request_destroy(user)
		@user = user
		mail(to: @user.email, subject: 'Solicitud para eliminar mi cuenta')
	end

	def request_destroy_admin(user)
    @user = user
		@bookings = @user.bookings
		@locations = @user.locations
		mail(to: Conf.value('admin_email'), subject: 'Usuario quiere borrar su cuenta')
  end
end

class UserMailer < ApplicationMailer
	default from: "AtLocs <cdiaz@chilelocaciones.cl>"
	layout 'mailer'

	def welcome(user)
		@user = user
		mail(to: @user.email, subject: '¡Bienvenid@ a AtLocs!')
	end

	def confirmation(user)
		@user = user
		mail(to: @user.email, subject: 'Registrado correctamente')
	end

	def confirmation(user)
		@user = user
		mail(to: @user.email, subject: 'Registrado correctamente')
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

	def request_removal(location,user)
		@location = location
		@user = user
		mail(to: Conf.value('admin_email'),subject: "Solicitud eliminación #{@location.title}")
	end

	def booking_requested(booking)
		@user = booking.location.user
		@location = booking.location
		@booking=booking
		mail(to: @user.email, subject: 'Tienes una reserva para tu locación')
	end

	def booking_sent(booking)
		@user = booking.user
		@location = booking.location
		@booking=booking
		mail(to: @user.email, subject: 'Has creado una reserva')
	end

	def booking_accepted(booking)
		@user = booking.user
		@location = booking.location
		@booking=booking
		mail(to: @user.email, subject: 'Tu reserva ha sido aceptada')
	end

	def admin_booking_accepted(booking)
		@user = booking.user
		@location = booking.location
		@booking=booking
		mail(to: "cdiaz@chilelocaciones.cl", subject: "Reserva aceptada en el sistema")
	end


	def booking_cancelled(booking)
		@user = booking.user
		@location = booking.location
		@booking=booking
		mail(to: @user.email, subject: 'Tu reserva ha sido cancelada')
	end

	def booking_commented(booking, sender, comment)
		@user = sender
		@booking = booking
		@comment = comment
		mail(to: @user.email, subject: 'Tienes un mensaje en tu reserva')
	end

	def payment_confirmed(booking)
		@booking=booking
		@user=@booking.user
		mail(to: @user.email, subject: 'Tu pago ha sido confirmado')
	end

	def contact_form(email,body,subject)
		@body=body
		mail(to: Conf.value('admin_email'),subject: subject, from:email)
	end

	def request_password_token(code,email)
		@code=code
		mail(to: email, subject: 'Tu link para reestablecer tu cuenta')
	end

	def request_destroy(user)
		@user = code
		mail(to: @user.email, subject: 'Solicitud: Eliminar cuenta')
	end

	def delete_user(user)
    @user = user
		mail(to: Conf.value('admin_email'), subject: 'Usuario quiere borrar su cuenta')
  end
end

class UserMailer < ApplicationMailer
	default from: "AtLocs <cdiaz@chilelocaciones.cl>"
	layout 'mailer'

	def welcome(user)
		@user = user
		mail(to: @user.email, subject: '¡Bienvenid@ a AtLocs!')
	end

	def confirmation(user)
		@user = user
		mail(to: @user.email, subject: '¡Bienvenid@ a AtLocs!')
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

	def request_location_removal_admin(location,user)
		@location = location
		@user = user
		mail(to: Conf.value('admin_email'),subject: "Solicitud eliminación de locación #{@location.title}")
	end

	def booking_requested_admin(booking)
		@user = booking.user
		@location = booking.location
		@location_user = booking.location.user
		@booking=booking
		mail(to: Conf.value('admin_email'), subject: '¡Han solicitado una reserva!')
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
		@booking = booking
		@user = @booking.user
		mail(to: @user.email, subject: '¡Ya tienes una reserva lista en AtLocs!')
	end

	def payment_confirmed_owner(booking)
		@booking = booking
		@user = booking.user
		@owner = @booking.location.user
		mail(to: @user.email, subject: '¡Tu locación ha sido arrendada con éxito!')
	end	

	def payment_confirmed_admin(booking)
		@booking = booking
		@location = booking.location
		mail(to: Conf.value('admin_email'), subject: 'Se ha completado una Reserva. ')
	end	

	def contact_form(email,body,subject)
		@body=body
		mail(to: Conf.value('admin_email'),subject: subject, from:email)
	end

	def request_password_token(user, code,email)
		@code = code
		@user = user
		mail(to: email, subject: '¿Olvidaste tu contraseña?')
	end

	def password_changed(user)
		@user = user
		mail(to: @user.email, subject: 'Tu contraseña ha sido cambiada')
	end

	def request_destroy(user)
		@user = user
		mail(to: @user.email, subject: 'Solicitud para eliminar mi cuenta')
	end

	def request_destroy_admin(user, reason)
    @user = user
		@bookings = @user.bookings
		@locations = @user.locations
		@reason = reason
		mail(to: Conf.value('admin_email'), subject: 'Usuario quiere borrar su cuenta')
  end

	def owner_location_review(booking)
		@user = booking.location.user
		@location = booking.location
		@booking = booking
		mail(to: @user.email, subject: 'Arriendo finalizado')
	end

	def tenant_location_review(booking)
		@user = booking.user
		@booking = booking
		mail(to: @user.email, subject: 'Cuéntanos tu experiencia')
	end

	def booking_edit(booking)
		@user = booking.user
		@booking = booking
		mail(to: @user.email, subject: 'Cambio de fecha de reserva')
	end

	def booking_edit_request(booking)
		@user = booking.location.user
		mail(to: @user.email, subject: 'Solicitud de cambio de reserva')
	end
end

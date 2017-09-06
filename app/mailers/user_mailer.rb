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

	def request_location_removal_owner(location, reason)
		@location = location
		@user = location.user
		@reason = reason
		mail(to: @user.email,subject: "Eliminación de Locación ")
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
		mail(to: @owner.email, subject: '¡Tu locación ha sido arrendada con éxito!')
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
		mail(to: @user.email, subject: 'Eliminación de Cuenta.')
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

	def booking_edit_request(booking, old_start, old_end)
		@user = booking.location.user
		@booking = booking
		@old_start = old_start
		@old_end = old_end
		mail(to: @user.email, subject: 'Solicitud de cambio de reserva')
	end

	def client_booking_cancel(booking, reason)
		@user = booking.user
		@booking = booking
		@reason = reason
		mail(to: @user.email, subject: 'Has cancelado una Reserva.')
	end

	def owner_booking_cancel(booking, reason)
		@booking = booking
		@reason = reason
		@user = booking.location.user
		mail(to: @user.email, subject: " La Reserva para tu locación #{booking.location.title} ha sido cancelada. ")
	end

	def client_booking_cancel_by_owner(booking, reason)
		@user = booking.user
		@booking = booking
		@reason = reason
		mail(to: @user.email, subject: 'Han cancelado tu Reserva. ')
	end

	def owner_booking_cancel_by_owner(booking, reason)
		@booking = booking
		@reason = reason
		@user = booking.location.user
		mail(to: @user.email, subject: "Has cancelado la reserva para tu locación #{@booking.location.title}.")
	end
end

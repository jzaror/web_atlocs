class AdminMailer < ApplicationMailer
	layout 'mailer'

	def location_submitted_admin(location)
		@location = location
		admin_email = Conf.value('admin_email')
		mail(to: "atlocs.com@gmail.com", subject: '[ADMIN ATLOCS] Han publicado una nueva locación')
	end

	def request_location_removal_admin(location, reason)
		@location = location
		@user = location.user
		@reason = reason
		admin_email = Conf.value('admin_email')
		mail(to: "atlocs.com@gmail.com",subject: "[ADMIN ATLOCS] Eliminación de Locación ")
	end

	def booking_requested_admin(booking)
		@user = booking.user
		@location = booking.location
		@location_user = booking.location.user
		@booking=booking
		admin_email = Conf.value('admin_email')
		mail(to: "atlocs.com@gmail.com", subject: '[ADMIN ATLOCS]¡Han solicitado una reserva!')
	end

	def payment_confirmed_admin(booking)
		@booking = booking
		@location = booking.location
		admin_email = Conf.value('admin_email')
		mail(to: "atlocs.com@gmail.com", subject: ' [ADMIN ATLOCS]Se ha completado una Reserva. ')
	end

	def request_destroy_admin(user, reason)
    @user = user
		@bookings = @user.bookings
		@locations = @user.locations
		@reason = reason
		admin_email = Conf.value('admin_email')
		mail(to: "atlocs.com@gmail.com", subject: '[ADMIN ATLOCS] Eliminación de Cuenta.')
  end

  def admin_booking_created(booking)
		@user = booking.user
		@location = booking.location
		@booking=booking
		admin_email = Conf.value('admin_email')
		mail(to: "atlocs.com@gmail.com", subject: "[ADMIN ATLOCS] Reserva aceptada en el sistema")
	end

  def admin_booking_cancel(booking, reason)
		@user = booking.user
		@booking = booking
		@reason = reason
		admin_email = Conf.value('admin_email')
		mail(to: "atlocs.com@gmail.com", subject: "[ADMIN ATLOCS] La Reserva para la locación #{booking.location.title} ha sido cancelada. ")
	end

	def admin_booking_accepted(booking)
		@user = booking.user
		@location = booking.location
		@booking=booking
		admin_email = Conf.value('admin_email')
		mail(to: "atlocs.com@gmail.com", subject: "[ADMIN ATLOCS]  Reserva aceptada en el sistema")
	end

	def admin_booking_cancel_by_owner(booking, reason)
		@user = booking.location.user
		@booking = booking
		@reason = reason
		admin_email = Conf.value('admin_email')
		mail(to: "atlocs.com@gmail.com", subject: "[ADMIN ATLOCS]La Reserva para la locación #{@booking.location.title} ha sido cancelada. ")
	end
end
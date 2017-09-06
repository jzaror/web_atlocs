class UserMailerPreview < ActionMailer::Preview

	def welcome
		UserMailer.welcome(User.first)
	end

	def confirmation
		@user = User.first
		UserMailer.confirmation(@user)
	end

	def location_submitted
		UserMailer.location_submitted(Location.first)
	end

	def location_approved
		UserMailer.location_approved(Location.first)
	end

	def location_problem
		UserMailer.location_problem(Location.first)
	end

	def request_location_removal_admin
		location = Location.first
		AdminMailer.request_location_removal_admin(location, location.user)
	end

	def booking_requested
		UserMailer.booking_requested(Booking.first)
	end

	def booking_requested_admin
		AdminMailer.booking_requested_admin(Booking.first)
	end

	def booking_sent
		UserMailer.booking_sent(Booking.first)
	end

	def booking_accepted
		UserMailer.booking_accepted(Booking.first)
	end

	def booking_cancelled
		UserMailer.booking_cancelled(Booking.first)
	end

	def booking_commented
		booking = Booking.first
		UserMailer.booking_commented(booking, booking.user)
	end

	def payment_confirmed
		UserMailer.payment_confirmed(Booking.first)
	end

	def contact_form
		UserMailer.contact_form('hola@nnodes.com', 'body content', 'subject')
	end

	def request_password_token
		UserMailer.request_password_token(User.first, 'abcdef', 'hola@nnodes.com')
	end

	def request_destroy
		@user = User.first
		UserMailer.request_destroy(@user)
	end

	def request_destroy_admin
		@user = User.first
		AdminMailer.request_destroy_admin(@user)
	end

end

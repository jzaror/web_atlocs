class CommentsController < ApplicationController
	load_and_authorize_resource
	def create
		@booking=Booking.find(params[:booking])
		@comment=Comment.new
		@comment.body=params[:body]
		@comment.booking_id=@booking.id
		UserMailer.booking_commented(@comment).deliver
	end
end

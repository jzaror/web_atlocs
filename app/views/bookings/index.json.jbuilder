json.array!(@bookings) do |booking|
  json.extract! booking, :id
  new_color = '#fff'
  if booking.user == @user
    new_color = '#42FF00'  # Green
  else
    new_color = '#FF0500'  # Red
  end
  json.title booking.location.title
  json.start booking.start_time
  json.end booking.end_time
  json.allDay false
  json.color new_color
  json.description booking.location.street_address
  json.url Rails.application.routes.url_helpers.bookings_path(booking.id)
end

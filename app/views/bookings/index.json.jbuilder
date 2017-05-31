json.array!(@bookings) do |booking|
  json.extract! booking, :id
  new_color = '#fff'
  if booking.user == @user
    new_color = '#3f9f3f'  # Green
    new_color = '#6bacc1' if booking.status != "waiting"  # Blue
  else
    new_color = '#ffbb3f'  # Yellow
    new_color = '#ff3f3f' if booking.status != "waiting"  # Red
  end
  json.title booking.location.title
  json.start booking.start_time
  json.end booking.end_time
  json.allDay false
  json.color new_color
  json.description booking.location.street_address
  json.url Rails.application.routes.url_helpers.bookings_path(booking.id)
end

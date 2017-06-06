json.array!(@bookings) do |booking|
  json.extract! booking, :id
  new_color = '#fff'
  if booking.status == "waiting"
    new_color = '#ADA3E6'
  else
    new_color = '#5B46CD'
  end
  json.title booking.location.title
  json.start booking.start_time
  json.end booking.end_time
  json.allDay true
  json.color new_color
  json.description booking.location.street_address
  json.url Rails.application.routes.url_helpers.bookings_path(booking.id)
end

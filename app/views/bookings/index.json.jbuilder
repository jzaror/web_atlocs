json.array!(@bookings) do |booking|
  json.extract! booking, :id
  json.title booking.location.title
  json.start booking.start_time
  json.end booking.end_time
  json.allDay true
  json.description booking.location.street_address
  json.url Rails.application.routes.url_helpers.bookings_path(booking.id)
end

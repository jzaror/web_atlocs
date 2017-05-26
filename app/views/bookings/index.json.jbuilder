json.array!(@bookings) do |booking|
  json.extract! booking, :id
  json.title booking.location.title
  json.start booking.start_time
  #json.start_date l(booking.start_date, format: "%A %d - %H:%M")
  json.end booking.end_time
  json.allDay false
  json.description booking.location.street_address
  json.url Rails.application.routes.url_helpers.activities_path(booking.id)
end

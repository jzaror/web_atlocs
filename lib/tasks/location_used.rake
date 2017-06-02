namespace :location_used do
  desc 'Send evaluation form'
  task send_form: :environment do
    yesterday = Date.yesterday
    Booking.where('end_time >= :start AND end_time <= :end',
                  start: yesterday.to_time.beginning_of_day,
                end: yesterday.to_time.end_of_day).each do |booking|
      booking
    end
  end
end

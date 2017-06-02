namespace :location_used do
  desc 'Send evaluation form'
  task send_form: :environment do
    yesterday = Date.yesterday
    Booking.where('end_time >= :start AND end_time <= :end AND status IN (:status)',
                  start: yesterday.to_time.beginning_of_day,
                  end: yesterday.to_time.end_of_day,
                  status: [2, 3]).each do |booking|
      UserMailer.tenant_location_review(booking).deliver_now
      UserMailer.owner_location_review(booking).deliver_now
    end
  end
end

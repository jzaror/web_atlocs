class ChangeEndDateFormat < ActiveRecord::Migration
   def up
    change_column :bookings, :end_time, :datetime
  end

  def down
    change_column :bookings, :end_time, :date
  end
end

class ChangeStartDateFormat < ActiveRecord::Migration
  def up
    change_column :bookings, :start_time, :datetime
  end

  def down
    change_column :bookings, :start_time, :date
  end
end

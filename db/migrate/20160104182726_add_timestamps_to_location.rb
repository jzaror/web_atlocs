class AddTimestampsToLocation < ActiveRecord::Migration
  def change
    add_timestamps(:bookings)
  end
end

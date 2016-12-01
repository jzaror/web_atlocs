class AddStatusToBooking < ActiveRecord::Migration
  def change
    add_column :bookings, :status, :integer
  end
end

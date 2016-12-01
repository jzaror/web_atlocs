class AddPriceToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :price, :decimal, :precision => 10, :scale => 2
  end
end

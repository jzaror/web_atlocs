class ChangePricesToIntegers < ActiveRecord::Migration
  def change
  	change_column :locations, :price, :integer
  	change_column :bookings, :price, :integer
  end
end

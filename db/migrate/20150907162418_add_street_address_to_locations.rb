class AddStreetAddressToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :street_address, :text
  end
end

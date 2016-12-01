class AddCountyToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :county, :string
  end
end

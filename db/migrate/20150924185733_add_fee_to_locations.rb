class AddFeeToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :fee, :decimal
  end
end

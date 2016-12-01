class AddFrontPageToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :front_page, :boolean
  end
end

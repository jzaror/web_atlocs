class AddOtherFieldsToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :other_extras_comment, :text
    add_column :locations, :other_services_comment, :text
  end
end

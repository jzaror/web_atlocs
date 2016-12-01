class AddLocationIdToUploads < ActiveRecord::Migration
  def change
    add_column :uploads, :location_id, :integer
  end
end

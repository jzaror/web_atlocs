class AddCollectionIdToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :collection_id, :integer
  end
end

class CreateCollectionMemberships < ActiveRecord::Migration
  def change
    create_table :collection_memberships do |t|
      t.integer :collection_id
      t.integer :location_id

      t.timestamps null: false
    end
  end
end

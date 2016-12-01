class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.integer :location_id
      t.string :url

      t.timestamps null: false
    end
  end
end

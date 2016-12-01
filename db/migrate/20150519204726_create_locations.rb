class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :title
      t.integer :days
      t.string :city
      t.string :type
      t.decimal :price, :precision => 10, :scale => 2
      t.text :description
      t.string :services
      t.string :extra
      t.string :address
      t.float :lat
      t.float :lng

      t.timestamps null: false
    end
  end
end

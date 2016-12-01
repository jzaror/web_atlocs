class AddImageToLocations < ActiveRecord::Migration
  def self.up
    add_attachment :locations, :image
  end

  def self.down
    remove_attachment :locations, :image
  end
end

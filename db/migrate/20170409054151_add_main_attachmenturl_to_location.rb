class AddMainAttachmenturlToLocation < ActiveRecord::Migration
  def change
  	add_column :locations, :main_attachment_id, :integer
  end
end

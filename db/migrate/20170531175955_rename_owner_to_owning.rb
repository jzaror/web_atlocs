class RenameOwnerToOwning < ActiveRecord::Migration
  def change
    rename_column :users, :owner, :owning
  end
end

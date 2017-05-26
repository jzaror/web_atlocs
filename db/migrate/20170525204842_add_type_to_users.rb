class AddTypeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :owner, :boolean
    add_column :users, :tenant, :boolean
  end
end

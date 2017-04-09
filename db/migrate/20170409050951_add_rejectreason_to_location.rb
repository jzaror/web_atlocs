class AddRejectreasonToLocation < ActiveRecord::Migration
  def change
  	add_column :locations, :reject_reason, :string
  end
end

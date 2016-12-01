class AddUserRefsToLocation < ActiveRecord::Migration
  def change
  	add_reference :locations, :user, index: true
  end
end

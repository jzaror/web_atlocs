class VerifyAllExistingUsers < ActiveRecord::Migration
  def change
  	User.where("status NOT IN (?)", [3,4,5]).update_all(status: 3)
  end
end

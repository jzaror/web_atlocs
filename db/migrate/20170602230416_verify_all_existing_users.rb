class VerifyAllExistingUsers < ActiveRecord::Migration
  def change
  	User.update_all(status: "verified")
  end
end

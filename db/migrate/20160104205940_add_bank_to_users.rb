class AddBankToUsers < ActiveRecord::Migration
  def change
    add_column :users, :deposit_bank, :string
    add_column :users, :deposit_account, :string
  end
end

class AddBullToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :bull_id, :integer
  end
end

class AddAccountToPlan < ActiveRecord::Migration
  def change
    add_column :plans, :account_id, :integer
    add_index :plans, :account_id
  end
end

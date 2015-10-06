class AddPaymentToSubscriptions < ActiveRecord::Migration
  def change
    add_column :payments, :subscription_id, :integer
    add_index :payments, :subscription_id
  end
end

class AddSubscriptionPaymentToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :subscription_id, :integer
    add_index :invoices, :subscription_id
  end
end

class AddAccountPaymentProcessorToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :account_payment_processor_id, :integer
    add_index :subscriptions, :account_payment_processor_id
  end
end

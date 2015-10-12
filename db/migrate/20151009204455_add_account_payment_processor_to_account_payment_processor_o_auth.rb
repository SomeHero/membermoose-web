class AddAccountPaymentProcessorToAccountPaymentProcessorOAuth < ActiveRecord::Migration
  def change
    add_column :account_payment_processor_oauths, :account_payment_processor_id, :integer
    add_index :account_payment_processor_oauths, :account_payment_processor_id, :unique => true, :name => 'oauth_index'
  end
end

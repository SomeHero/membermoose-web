class RemoveAccountPaymentProcessorFromPayments < ActiveRecord::Migration
  def change
      remove_column :payments, :account_payment_processor_id
  end
end

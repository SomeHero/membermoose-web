class AddPaymentProcessorToPayment < ActiveRecord::Migration
  def change
    add_column :payments, :payment_processor_id, :integer
  end
end

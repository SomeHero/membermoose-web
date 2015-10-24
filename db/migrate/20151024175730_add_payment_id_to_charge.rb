class AddPaymentIdToCharge < ActiveRecord::Migration
  def change
    add_column :charges, :payment_id, :integer
  end
end

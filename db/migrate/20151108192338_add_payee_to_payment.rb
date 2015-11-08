class AddPayeeToPayment < ActiveRecord::Migration
  def change
    add_column :payments, :payee_id, :integer
  end
end

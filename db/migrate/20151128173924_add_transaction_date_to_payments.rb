class AddTransactionDateToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :transaction_date, :datetime, :default  => Time.now
  end
end

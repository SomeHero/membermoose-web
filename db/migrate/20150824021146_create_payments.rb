class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.references :account, index: true
      t.references :account_payment_processor, index: true
      t.decimal :amount
      t.decimal :payment_processor_fee
      t.string :payment_type
      t.string :status

      t.timestamps
    end
  end
end

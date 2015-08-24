class CreateSubscriptionPayments < ActiveRecord::Migration
  def change
    create_table :subscription_payments do |t|
      t.references :subscription, index: true
      t.references :payment, index: true

      t.timestamps
    end
  end
end

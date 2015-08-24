class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.references :account, index: true
      t.references :plan, index: true
      t.references :account_payment_method, index: true
      t.string :status

      t.timestamps
    end
  end
end

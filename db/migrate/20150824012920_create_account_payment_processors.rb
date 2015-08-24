class CreateAccountPaymentProcessors < ActiveRecord::Migration
  def change
    create_table :account_payment_processors do |t|
      t.references :account, index: true
      t.references :payment_processor, index: true
      t.json :raw_response
      t.string :stripe_user_id
      t.string :stripe_refresh_token
      t.string :stripe_access_token
      t.boolean :active

      t.timestamps
    end
  end
end

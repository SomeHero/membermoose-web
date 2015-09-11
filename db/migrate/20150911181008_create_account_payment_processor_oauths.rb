class CreateAccountPaymentProcessorOauths < ActiveRecord::Migration
  def change
    create_table :account_payment_processor_oauths do |t|
      t.references :account, index: true
      t.references :payment_processor, index: true
      t.text :raw_response
      t.string :oauth_user_id
      t.string :name
      t.string :email
      t.string :token
      t.string :refresh_token

      t.timestamps
    end
  end
end

class AddAccessTokenToAccountPaymentProcessor < ActiveRecord::Migration
  def change
    rename_column :account_payment_processors, :token, :api_key
    add_column :account_payment_processors, :secret_token, :string
  end
end

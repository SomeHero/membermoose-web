class FixUpAccountPaymentProcessors < ActiveRecord::Migration
  def change
    rename_column :account_payment_processors, :stripe_user_id, :oauth_user_id
    add_column :account_payment_processors, :name, :string
    add_column :account_payment_processors, :email, :string
    rename_column :account_payment_processors, :stripe_access_token, :token
    rename_column :account_payment_processors, :stripe_refresh_token, :refresh_token
  end
end

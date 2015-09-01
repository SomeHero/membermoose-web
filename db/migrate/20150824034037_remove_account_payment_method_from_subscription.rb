class RemoveAccountPaymentMethodFromSubscription < ActiveRecord::Migration
  def change
        remove_column :subscriptions, :account_payment_method_id
  end
end

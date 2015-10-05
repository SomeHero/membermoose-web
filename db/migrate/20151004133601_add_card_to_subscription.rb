class AddCardToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :card_id, :integer
    add_index :subscriptions, :card_id
  end
end

class ChangeSubscriptionStatusToInt < ActiveRecord::Migration
  def change
    drop_column :subscriptions, :status
    add_column :subscriptions, :status, :integer, :default => 1
  end
end

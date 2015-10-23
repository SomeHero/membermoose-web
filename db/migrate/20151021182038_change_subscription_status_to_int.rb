class ChangeSubscriptionStatusToInt < ActiveRecord::Migration
  def change
    change_column :subscriptions, :status, default: 0
  end
end

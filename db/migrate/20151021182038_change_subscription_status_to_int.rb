class ChangeSubscriptionStatusToInt < ActiveRecord::Migration
  def change
    change_column :subscriptions, :status, :integer, :default => 0
  end
end

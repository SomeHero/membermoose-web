class AddGuids < ActiveRecord::Migration
  def change
    add_column :plans, :guid, :string
    add_column :accounts, :guid, :string
    add_column :subscriptions, :guid, :string
    add_column :payments, :guid, :string
  end
end

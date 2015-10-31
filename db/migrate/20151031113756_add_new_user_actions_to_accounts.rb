class AddNewUserActionsToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :has_uploaded_logo, :boolean, :default => false
    add_column :accounts, :has_setup_subdomain, :boolean, :default => false
    add_column :accounts, :has_created_plan, :boolean, :default => false
    add_column :accounts, :has_connected_stripe, :boolean, :default => false
    add_column :accounts, :has_upgraded_plan, :boolean, :default => false
  end
end

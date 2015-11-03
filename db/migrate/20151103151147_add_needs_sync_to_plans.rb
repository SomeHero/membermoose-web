class AddNeedsSyncToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :needs_sync, :boolean, :default => false
  end
end

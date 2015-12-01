class AddDeletedToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :deleted, :boolean, :default => false
    add_column :plans, :deleted_at, :datetime
  end
end

class AddPublicToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :public, :boolean
  end
end

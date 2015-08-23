class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :name
      t.text :description
      t.decimal :amount
      t.string :billing_cycle
      t.string :billing_interval
      t.integer :trail_period_days
      t.text :terms_and_conditions

      t.timestamps
    end
  end
end

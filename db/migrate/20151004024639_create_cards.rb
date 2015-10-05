class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.references :account, index: true
      t.string :brand
      t.string :last4
      t.integer :expiration_month
      t.integer :expiration_year

      t.timestamps
    end
  end
end

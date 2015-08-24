class CreatePaymentProcessors < ActiveRecord::Migration
  def change
    create_table :payment_processors do |t|
      t.string :name
      t.boolean :active

      t.timestamps
    end
  end
end

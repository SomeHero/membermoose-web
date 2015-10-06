class CreateCharges < ActiveRecord::Migration
  def change
    create_table :charges do |t|
      t.string :status
      t.decimal :amount
      t.string :currency
      t.references :card, index: true
      t.string :external_invoice_id

      t.timestamps
    end
  end
end

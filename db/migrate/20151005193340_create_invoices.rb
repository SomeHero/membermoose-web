class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.string :external_id
      t.decimal :subtotal
      t.decimal :total
      t.string :status

      t.timestamps
    end
  end
end

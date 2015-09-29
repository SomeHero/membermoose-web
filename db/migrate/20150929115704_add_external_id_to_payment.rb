class AddExternalIdToPayment < ActiveRecord::Migration
  def change
    add_column :payments, :external_id, :string
  end
end

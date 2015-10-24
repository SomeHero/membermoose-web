class AddExternalIdToCharge < ActiveRecord::Migration
  def change
    add_column :charges, :external_id, :string
  end
end

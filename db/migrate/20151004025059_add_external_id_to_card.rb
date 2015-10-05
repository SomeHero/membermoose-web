class AddExternalIdToCard < ActiveRecord::Migration
  def change
    add_column :cards, :external_id, :string
  end
end

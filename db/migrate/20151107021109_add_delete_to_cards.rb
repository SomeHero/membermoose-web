class AddDeleteToCards < ActiveRecord::Migration
  def change
    add_column :cards, :deleted, :boolean, :default => false
    add_column :cards, :deleted_at, :datetime
  end
end

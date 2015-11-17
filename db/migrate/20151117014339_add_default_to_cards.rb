class AddDefaultToCards < ActiveRecord::Migration
  def change
    add_column :cards, :default, :boolean, :default => false
  end
end

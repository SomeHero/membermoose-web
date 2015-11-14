class AddNameOnCardToCard < ActiveRecord::Migration
  def change
    add_column :cards, :name_on_card, :string
  end
end

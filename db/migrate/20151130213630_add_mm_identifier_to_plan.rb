class AddMmIdentifierToPlan < ActiveRecord::Migration
  def change
    add_column :plans, :mm_identifier, :string
  end
end

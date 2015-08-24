class RemoveAddressFromAccount < ActiveRecord::Migration
  def change
    remove_column :accounts, :address_id
  end
end

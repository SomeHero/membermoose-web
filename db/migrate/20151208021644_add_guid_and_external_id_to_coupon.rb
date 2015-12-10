class AddGuidAndExternalIdToCoupon < ActiveRecord::Migration
  def change
    add_column :coupons, :guid, :string
    add_column :coupons, :external_id, :string
  end
end

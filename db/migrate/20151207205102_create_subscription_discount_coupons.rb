class CreateSubscriptionDiscountCoupons < ActiveRecord::Migration
  def change
    create_table :subscription_discount_coupons do |t|
      t.references :plan, index: true
      t.references :coupon, index: true

      t.timestamps
    end
  end
end

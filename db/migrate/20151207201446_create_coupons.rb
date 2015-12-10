class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
      t.integer :coupon_type
      t.decimal :discount_amount
      t.string :currency
      t.integer :duration
      t.integer :duration_repeating_monthes
      t.integer :max_redemptions
      t.timestamp :redeem_by
      t.integer :times_redeemed

      t.timestamps
    end
  end
end

class Coupon < ActiveRecord::Base
  enum coupon_type: %w(amount percentage)
  enum duration: %w(forever once repeating)


end

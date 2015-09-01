class Subscription < ActiveRecord::Base
  belongs_to :account
  belongs_to :plan
  belongs_to :account_payment_processor
end

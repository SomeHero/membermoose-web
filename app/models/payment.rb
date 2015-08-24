class Payment < ActiveRecord::Base
  belongs_to :account
  belongs_to :account_payment_processor
end

class AccountPaymentProcessor < ActiveRecord::Base
  belongs_to :account
  belongs_to :payment_processor
end

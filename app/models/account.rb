class Account < ActiveRecord::Base
  belongs_to :user
  has_one :address
  has_many :account_payment_processors

end

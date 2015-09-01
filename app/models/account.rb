class Account < ActiveRecord::Base
  belongs_to :user
  has_one :address
  has_many :account_payment_processors
  has_attached_file :logo

  validates_attachment :logo, content_type: { content_type: /\Aimage\/.*\Z/ }

end

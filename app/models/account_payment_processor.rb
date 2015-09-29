class AccountPaymentProcessor < ActiveRecord::Base
  belongs_to :account
  belongs_to :payment_processor

  has_many :payments

  def as_json(options={})
  {
    :id => self.id,
    :payment_processor => self.payment_processor,
    :active => self.active,
    :created_at => self.created_at,
    :updated_at	=> self.updated_at
  }
  end
  
end

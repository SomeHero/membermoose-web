class AccountPaymentProcessor < ActiveRecord::Base
  belongs_to :account
  belongs_to :payment_processor

  has_many :payments

  scope :active, -> { where(active: true) }

  def as_json(options={})
  {
    :id => self.id,
    :payment_processor => self.payment_processor,
    :oauth_user_id => self.oauth_user_id,
    :name => self.name,
    :email => self.email,
    :api_key => self.api_key,
    :active => self.active,
    :created_at => self.created_at,
    :updated_at	=> self.updated_at
  }
  end

end

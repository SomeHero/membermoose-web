class AccountPaymentProcessorOauth < ActiveRecord::Base
  belongs_to :account_payment_processor

  def as_json(options={})
  {
    :id => self.id,
    :account_payment_processor => self.account_payment_processor,
    :oauth_user_id => self.oauth_user_id,
    :name => self.name,
    :email => self.email,
    :token => self.token
  }
  end
end

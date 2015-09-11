class AccountPaymentProcessorOauth < ActiveRecord::Base
  belongs_to :account
  belongs_to :payment_processor

  def as_json(options={})
  {
    :id => self.id,
    :payment_processor => self.payment_processor.name,
    :oauth_user_id => self.oauth_user_id,
    :name => self.name,
    :email => self.email,
    :token => self.token
  }
  end
end

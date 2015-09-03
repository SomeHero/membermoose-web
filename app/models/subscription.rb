class Subscription < ActiveRecord::Base
  belongs_to :account
  belongs_to :plan
  belongs_to :account_payment_processor

  def as_json(options={})
  {
    :id => self.id,
    :plan => self.plan,
    :subscriber => self.account,
    :status => self.status,
    :created_at => self.created_at,
    :updated_at	=> self.updated_at
  }
  end
end

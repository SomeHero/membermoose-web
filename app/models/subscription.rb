class Subscription < ActiveRecord::Base
  belongs_to :account
  belongs_to :plan
  belongs_to :account_payment_processor

  before_save :populate_guid
  validates_uniqueness_of :guid

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

  private

  def populate_guid
    if new_record?
      while !valid? || self.guid.nil?
        self.guid = SecureRandom.random_number(1_000_000_000).to_s(36)
      end
    end
  end
end

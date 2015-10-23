class Subscription < ActiveRecord::Base
  enum status: %w(subscribed cancelled)

  belongs_to :account
  belongs_to :plan
  belongs_to :account_payment_processor
  belongs_to :card

  has_many :invoices
  has_many :payments

  before_save :populate_guid
  validates_uniqueness_of :guid

  def as_json(options={})
  {
    :id => self.id,
    :guid => self.guid,
    :plan => self.plan,
    :subscriber => self.account,
    :status => self.status,
    :created_at => self.created_at,
    :updated_at	=> self.updated_at
  }
  end

  def last_invoice_date

  end

  def next_invoice_date

  end

  def next_invoice_amount

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

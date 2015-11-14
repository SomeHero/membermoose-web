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
    :subscriberName => self.account.full_name,
    :last_payment_date => self.last_payment_date,
    :last_payment_amount => self.last_payment_amount,
    :next_invoice_date => self.next_invoice_date,
    :next_invoice_amount => self.next_invoice_amount,
    :status => self.status.titlecase,
    :created_at => self.created_at,
    :updated_at	=> self.updated_at
  }
  end

  def last_payment_date
    payments.order("created_at desc").last.created_at if payments.count > 0
  end

  def last_payment_amount
    payments.last.amount if payments.count > 0
  end

  def next_invoice
    invoices.where(:external_id => "").order("created_at desc").first
  end

  def next_invoice_date
    next_invoice.due_date if next_invoice
  end

  def next_invoice_amount
    next_invoice.total if next_invoice
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

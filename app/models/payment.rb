class Payment < ActiveRecord::Base
  belongs_to :account
  belongs_to :account_payment_processor
  belongs_to :card
  belongs_to :payment
  
  before_save :populate_guid
  validates_uniqueness_of :guid

  def net_amount
    self.amount - self.payment_processor_fee
  end

  def as_json(options={})
  {
    :id => self.id,
    :guid => self.guid,
    :amount => self.amount,
    :fees => self.payment_processor_fee,
    :net_amount => self.net_amount,
    :payment_type => self.payment_type,
    :payment_method => self.payment_method,
    :status => self.status,
    :payee => {
      "guid" => self.account_payment_processor.account.guid,
      "full_name" => self.account_payment_processor.account.full_name,
      "email_address" => self.account_payment_processor.account.user.email
    },
    :account_payment_processor => self.account_payment_processor,
    :card => self.card,
    :comments => self.comments,
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

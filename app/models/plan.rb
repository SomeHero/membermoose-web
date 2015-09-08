class Plan < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  belongs_to :account
  has_many :subscriptions

  has_attached_file :photo

  scope :public_plans, -> { where(public: true) }

  before_save :populate_guid
  validates_uniqueness_of :guid, :allow_blank => true, :allow_nil => true

  def as_json(options={})
  {
    :id => self.id,
    :name => self.name,
    :description => self.description,
    :amount => self.amount,
    :billing_cycle => self.billing_cycle,
    :billing_interval => self.billing_interval,
    :trial_period_days => self.trial_period_days,
    :terms_and_conditions => self.terms_and_conditions,
    :public => self.public,
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

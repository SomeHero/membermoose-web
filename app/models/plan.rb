class Plan < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  belongs_to :account
  has_many :subscriptions
  has_many :members, :through => :subscriptions, :source => :account, class_name: "Account", foreign_key: "account_id"
  has_attached_file :photo

  scope :public_plans, -> { where(public: true) }

  before_save :populate_guid
  after_update :save_to_stripe
  validates_uniqueness_of :guid, :allow_blank => true, :allow_nil => true

  def as_json(options={})
  {
    :id => self.id,
    :guid => self.guid,
    :name => self.name,
    :account => self.account,
    :description => self.description,
    :feature_1 => self.feature_1,
    :feature_2 => self.feature_2,
    :feature_3 => self.feature_3,
    :feature_4 => self.feature_4,
    :amount => self.amount,
    :billing_cycle => self.billing_cycle,
    :billing_interval => self.billing_interval,
    :trial_period_days => self.trial_period_days,
    :terms_and_conditions => self.terms_and_conditions,
    :public => self.public,
    :subscriber_limit => self.subscriber_limit,
    :subscriber_count => self.subscriber_count,
    :stripe_id => self.stripe_id,
    :created_at => self.created_at,
    :updated_at	=> self.updated_at
  }
  end

  def subscriber_limit
    if self.account.has_upgraded_plan
      return 0
    else
      return 5
    end
  end

  def subscriber_count
    members.count
  end

  def can_subscribe?
    if subscriber_limit == 0
      return true
    end

    if subscriber_count < subscriber_limit
      return true
    end

    return false
  end

  private

  def populate_guid
    if new_record?
      while !valid? || self.guid.nil?
        self.guid = SecureRandom.random_number(1_000_000_000).to_s(36)
      end
    end
  end

  def save_to_stripe
    #UpdatePlan.call(self)
  end
end

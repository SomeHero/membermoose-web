class Account < ActiveRecord::Base
  belongs_to :user
  has_one :address
  has_many :plans
  has_many :subscriptions, -> { includes :plan }
  has_many :subscriptions_plans,  -> { includes :plan }, :through => :plans, :source => :subscriptions
  has_many :members, :through => :plans
  has_many :account_payment_processors
  has_many :payments
  has_many :bills, :through => :account_payment_processors, :source => :payments
  has_many :cards
  has_attached_file :logo
  has_attached_file :photo

  accepts_nested_attributes_for :user, :update_only => true

  validates_attachment :logo, content_type: { content_type: /\Aimage\/.*\Z/ }

  DISALLOWED_SUBDOMAINS = %w(admin www app signup sign-up sign_up administration membermoose-ng)
  SUBDOMAIN_MIN_LENGTH = 3
  SUBDOMAIN_MAX_LENGTH = 20

  #validates :subdomain, :length => (SUBDOMAIN_MIN_LENGTH..SUBDOMAIN_MAX_LENGTH), :format => { :with => /^[\w-]+$/ }, :presence   => true, :uniqueness => true, :exclusion => { :in => DISALLOWED_SUBDOMAINS }

  before_update :update_site_url
  before_save :populate_guid
  validates_uniqueness_of :guid

  def full_name
    self.first_name + " " + self.last_name
  end

  def plan_names
    self.subscriptions.pluck('plans.name').join(', ')
  end

  def status
    self.subscriptions.where(:status => Subscription.statuses[:subscribed]).count > 0 ? "active" : "inactive"
  end

  def as_json(options={})
    protocol = "http://"
    domain_suffix = "mmoose-ng.localhost:3000"

    {
      :id => self.id,
      :guid => self.guid,
      :first_name => self.first_name,
      :last_name => self.last_name,
      :company_name => self.company_name,
      :logo => {
        url: self.logo.exists? ? self.logo.url : ""
      },
      :user => {
        :email => self.user.email,
      },
      :subdomain => self.subdomain,
      :site_url => self.site_url,
      :plan_names => self.plan_names,
      :payment_processors => self.account_payment_processors.active,
      :billing_history => self.bills,
      :status => self.status,
      :hasUploadedLogo => self.has_uploaded_logo,
      :hasSetupSubdomain => self.has_setup_subdomain,
      :hasCreatedPlan => self.has_created_plan,
      :hasConnectedStripe => self.has_connected_stripe,
      :hasUpgradedPlan => self.has_upgraded_plan,
      :cards => (self.cards.active ? self.cards.active : nil),
      :createdAt => self.created_at,
      :updatedAt	=> self.updated_at
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
  def build_site_url subdomain
    if Rails.env.production?
      site_url ="https://#{subdomain}.membermoose-ng.com"
    else
      site_url = "http://#{subdomain}.mmoose-ng.localhost:3000/"
    end
    return site_url
  end
  def update_site_url
    if self.subdomain_changed?
      self.site_url =build_site_url(self.subdomain)
    end
  end
end

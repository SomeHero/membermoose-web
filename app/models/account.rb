class Account < ActiveRecord::Base
  belongs_to :user
  belongs_to :bull, class_name: "Account", foreign_key: "bull_id"
  has_one :address
  has_many :plans
  has_many :subscriptions, -> { includes :plan }
  has_many :subscriptions_plans,  -> { includes :plan }, :through => :plans, :source => :subscriptions
  has_many :members, :through => :plans
  has_many :account_payment_processors
  has_many :payments
  has_many :cards
  has_attached_file :logo
  has_attached_file :photo

  accepts_nested_attributes_for :user, :update_only => true

  validates_attachment :logo, content_type: { content_type: /\Aimage\/.*\Z/ }

  DISALLOWED_SUBDOMAINS = %w(admin www app signup sign-up sign_up administration membermoose-ng)
  SUBDOMAIN_MIN_LENGTH = 3
  SUBDOMAIN_MAX_LENGTH = 20

  enum role: %w(calf bull superadmin)

  #validates :subdomain, :length => (SUBDOMAIN_MIN_LENGTH..SUBDOMAIN_MAX_LENGTH), :format => { :with => /^[\w-]+$/ }, :presence   => true, :uniqueness => true, :exclusion => { :in => DISALLOWED_SUBDOMAINS }

  before_update :update_site_url
  before_save :populate_guid
  validates_uniqueness_of :guid

  def full_name
    if self.first_name && self.last_name
      self.first_name.to_s + " " + self.last_name.to_s
    else
      self.user.email
    end
  end

  def plan_names
    self.subscriptions.pluck('plans.name').join(', ')
  end

  def status
    self.subscriptions.where(:status => Subscription.statuses[:subscribed]).count > 0 ? "active" : "inactive"
  end

  def is_bull?
    return true if self.role == "bull" || self.role == "superadmin"

    return false
  end

  def logo_full_url
    if Rails.env.production?
      prefix = ""
    else
      prefix = "http://www.mmoose-ng.localhost:3000"
    end
    if self.logo.exists?
      logo_url = prefix + self.logo.url
    else
      logo_url = prefix + "mm-logo.png"
    end

    logo_url
  end

  def manage_account_url
    if Rails.env.production?
      prefix ="http://www.membermoose.com"
    else
      prefix = "http://www.mmoose-ng.localhost:3000"
    end

    return prefix + "/dashboard/plans"
  end

  def create_plan_url
    if Rails.env.production?
      prefix ="http://www.membermoose.com"
    else
      prefix = "http://www.mmoose-ng.localhost:3000"
    end

    return prefix + "/dashboard/plans/create"
  end

  def as_json(options={})
    protocol = "http://"
    domain_suffix = "mmoose-ng.localhost:3000"

    {
      :id => self.id,
      :guid => self.guid,
      :role => self.role,
      :bull_id => self.bull.id,
      :first_name => self.first_name,
      :last_name => self.last_name,
      :full_name => self.full_name,
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
      :subscriptions => self.subscriptions,
      :payment_processors => self.account_payment_processors.active,
      :billing_history => self.billing_history,
      :next_invoice_date => self.next_invoice_date,
      :status => self.status,
      :hasUploadedLogo => self.has_uploaded_logo,
      :hasSetupSubdomain => self.has_setup_subdomain,
      :hasCreatedPlan => self.has_created_plan,
      :hasConnectedStripe => self.has_connected_stripe,
      :hasUpgradedPlan => self.has_upgraded_plan,
      :cards => (self.cards.active ? self.cards.active : nil),
      :member_since => self.member_since,
      :createdAt => self.created_at,
      :updatedAt	=> self.updated_at
    }
  end

  def stripe_secret_key
    if self.bull
      stripe_payment_processor = PaymentProcessor.where(:name => "Stripe").first
      stripe_payment_processor = self.account_payment_processors.where(:payment_processor => stripe_payment_processor).active
    else
      stripe_payment_processor = PaymentProcessor.where(:name => "Stripe").first
      stripe_payment_processor = self.bull.account_payment_processors.where(:payment_processor => stripe_payment_processor).active
    end

    return nil if !stripe_payment_processor

    return stripe_payment_processor.first.secret_token
  end

  def billing_history
    results = []
    self.subscriptions.each do |subscription|
      results += subscription.billing_history
    end

    results.take(6)
  end

  def next_invoice_date
    result = nil
    self.subscriptions.each do |subscription|
      if !result
        result = subscription.next_invoice_date
      elsif subscription.next_invoice_date < result
        result = subscription.next_invoice_date
      end
    end

    result
  end
  def set_default_subdomain
    subdomain = self.company_name.gsub(/\s+/, '-').downcase

    #ToDo: we should check that this subdomain is available
    self.subdomain = subdomain
  end
  def subscribe_to_mm_free
    return if !is_bull?

    free_plan = Plan.find_by_stripe_id("MM_FREE")

    bull = free_plan.account
    payment_processor = PaymentProcessor.find_by(:name => "Stripe")

    begin
      Stripe.api_key =  bull.stripe_secret_key

      stripe_sub = nil
      if self.stripe_customer_id.blank?
        customer = Stripe::Customer.create(
          email: self.user.email,
          plan: free_plan.stripe_id,
        )
        self.stripe_customer_id = customer.id
        self.save!

        stripe_sub = customer.subscriptions.first
        stripe_card = customer.sources.first

        subscription = Subscription.new(
          plan: free_plan,
          account: self,
          status: Subscription.statuses[:subscribed],
          stripe_id: stripe_sub.id,
        )

        subscription.save!
      else
        customer = Stripe::Customer.retrieve(account.stripe_customer_id)
        stripe_sub = customer.subscriptions.create(
          plan: free_plan.stripe_id
        )
      end
    rescue Stripe::StripeError => e
      #we should log error messages
    end

    begin
      Resque.enqueue(UserSubscribedWorker, subscription.id)
    rescue
      Rails.logger.error "Error sending User Subscribed email #{$!}"
    end

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
      site_url ="https://#{subdomain}.membermoose.com"
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

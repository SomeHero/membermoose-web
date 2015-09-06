class Account < ActiveRecord::Base
  belongs_to :user
  has_one :address
  has_many :plans
  has_many :subscriptions, :through => :plans
  has_many :members, :through => :subscriptions, :source => :account, class_name: "Account", foreign_key: "account_id"
  has_many :account_payment_processors
  has_many :payments
  has_attached_file :logo
  has_attached_file :photo

  validates_attachment :logo, content_type: { content_type: /\Aimage\/.*\Z/ }

  DISALLOWED_SUBDOMAINS = %w(admin www app signup sign-up sign_up administration membermoose-ng)
  SUBDOMAIN_MIN_LENGTH = 3
  SUBDOMAIN_MAX_LENGTH = 20

  #validates :subdomain, :length => (SUBDOMAIN_MIN_LENGTH..SUBDOMAIN_MAX_LENGTH), :format => { :with => /^[\w-]+$/ }, :presence   => true, :uniqueness => true, :exclusion => { :in => DISALLOWED_SUBDOMAINS }

  def as_json(options={})
  {
    :id => self.id,
    :first_name => self.first_name,
    :last_name => self.last_name,
    :company_name => self.company_name,
    :user => {
      :email => self.user.email,
    },
    :created_at => self.created_at,
    :updated_at	=> self.updated_at
  }
  end
end

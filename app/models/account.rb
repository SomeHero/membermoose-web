class Account < ActiveRecord::Base
  belongs_to :user
  has_one :address
  has_many :account_payment_processors
  has_attached_file :logo

  validates_attachment :logo, content_type: { content_type: /\Aimage\/.*\Z/ }

  def as_json(options={})
  {
    :id => self.id,
    :first_name => self.first_name,
    :last_name => self.last_name,
    :company_name => self.company_name,
    :created_at => self.created_at,
    :updated_at	=> self.updated_at
  }
  end
end

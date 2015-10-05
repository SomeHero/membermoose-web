class Card < ActiveRecord::Base
  belongs_to :account

  def as_json(options={})
  {
    :id => self.id,
    :brand => self.brand,
    :last4 => self.last4,
    :expiration_month => self.expiration_month,
    :expiration_year => self.expiration_year,
    :created_at => self.created_at,
    :updated_at	=> self.updated_at
  }
  end
end

class Card < ActiveRecord::Base
  belongs_to :account

  scope :active, -> { where(deleted: false) }

  def as_json(options={})
  {
    :id => self.id,
    :name_on_card => self.name_on_card,
    :brand => self.brand,
    :last4 => self.last4,
    :expiration_month => self.expiration_month,
    :expiration_year => self.expiration_year,
    :created_at => self.created_at,
    :updated_at	=> self.updated_at
  }
  end
end

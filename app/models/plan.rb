class Plan < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  belongs_to :account

  def as_json(options={})
  {
    :id => self.id,
    :name => self.name,
    :description => self.description,
    :amount => self.amount,
    :billing_cycle => self.billing_cycle,
    :billing_interval => self.billing_interval,
    :trial_period_days => self.trail_period_days,
    :terms_and_conditions => self.terms_and_conditions,
    :created_at => self.created_at,
    :updated_at	=> self.updated_at
  }
  end
  
end

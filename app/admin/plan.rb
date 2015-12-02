ActiveAdmin.register Plan do
  permit_params :account, :name, :description, :amount, :billing_cycle, :billing_interval, :trial_period_days, :terms_and_conditions
  filter :account
  filter :name

end

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')

mm_user = User.create!({
  :email => 'admin@membermoose.com',
  :password => 'password'
  })
mm_account = Account.create!({
  :user => mm_user,
  :first_name => "James",
  :last_name => "Rhodes",
  :company_name => "Member Moose"
  #logo =>
  })
baby_moose = Plan.create!({
    :account => mm_account,
    :name => "Baby Moose",
    :description => "Unlimited plans but only 5 subscribers per plan",
    :amount => 0,
    :billing_cycle => "Monthly",
    :billing_interval => "1",
    :trial_period_days => 0,
    :terms_and_conditions => "Be cool"
})
big_moose = Plan.create!({
    :account => mm_account,
    :name => "StartUp Moose",
    :description => "Unlimited plans up to 100 subscribers per plan",
    :amount => "9.99",
    :billing_cycle => "Monthly",
    :billing_interval => "1",
    :trial_period_days => 30,
    :terms_and_conditions => "Be cool"
})
baby_moose = Plan.create!({
    :account => mm_account,
    :name => "Top Moose",
    :description => "Unlimited plans, unlimited subscribers",
    :amount => "29.99",
    :billing_cycle => "Monthly",
    :billing_interval => "1",
    :trial_period_days => 30,
    :terms_and_conditions => "Be cool"
})
mama_moose = Plan.create!({
    :account => mm_account,
    :name => "Mama Moose",
    :description => "Unlimited plans, unlimited subscribers but only if you're a mama moose",
    :amount => "19.99",
    :billing_cycle => "Monthly",
    :billing_interval => "1",
    :trial_period_days => 30,
    :terms_and_conditions => "Be cool"
})
papa_moose = Plan.create!({
    :account => mm_account,
    :name => "Papa Moose",
    :description => "Unlimited plans, unlimited subscribers but only if you're a papa moose",
    :amount => "299.99",
    :billing_cycle => "Monthly",
    :billing_interval => "1",
    :trial_period_days => 30,
    :terms_and_conditions => "Be cool"
})
enterprise_moose = Plan.create!({
    :account => mm_account,
    :name => "Enterprise Moose",
    :description => "Unlimited plans, unlimited subscribers for enterprise",
    :amount => "1000.99",
    :billing_cycle => "Monthly",
    :billing_interval => "1",
    :trial_period_days => 30,
    :terms_and_conditions => "Be cool"
})
special_moose = Plan.create!({
    :account => mm_account,
    :name => "Special Moose",
    :description => "Unlimited plans, unlimited subscribers for specials",
    :amount => "0.99",
    :billing_cycle => "Monthly",
    :billing_interval => "1",
    :trial_period_days => 30,
    :terms_and_conditions => "Be cool"
})
payment_processor = PaymentProcessor.create!({
  :name => "Stripe",
  :active => true
})

larkin_account = Account.create!({
  :user => User.create!({
    :email => 'contact@804RVA.com',
    :password => 'password'
  }),
  :first_name => "Larkin",
  :last_name => "Garbee",
  :company_name => "804RVA"
  #logo =>
})
Subscription.create!({
  :account => larkin_account,
  :plan => baby_moose,
  #:account_payment_method =>
  :status => "Active"
})

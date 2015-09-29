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
  :company_name => "804RVA",
  :subdomain => "804rva"
  #logo =>
})
Subscription.create!({
  :account => larkin_account,
  :plan => baby_moose,
  #:account_payment_method =>
  :status => "Active"
})
wolfpack_1_plan = Plan.create!({
    :account => larkin_account,
    :name => "Wolfpack 1",
    :description => "1 day per week",
    :amount => "50.00",
    :billing_cycle => "Monthly",
    :billing_interval => "1",
    :trial_period_days => 30,
    :terms_and_conditions => "Be cool",
    :public => true
})
wolfpack_2_plan = Plan.create!({
    :account => larkin_account,
    :name => "Wolfpack 2",
    :description => "3 days per week",
    :amount => "125.00",
    :billing_cycle => "Monthly",
    :billing_interval => "1",
    :trial_period_days => 30,
    :terms_and_conditions => "Be cool",
    :public => true
})
wolfpack_3_plan = Plan.create!({
    :account => larkin_account,
    :name => "Wolfpack 3",
    :description => "5 days per week",
    :amount => "200.00",
    :billing_cycle => "Monthly",
    :billing_interval => "1",
    :trial_period_days => 30,
    :terms_and_conditions => "Be cool",
    :public => true
})
wolfpack_4_plan = Plan.create!({
    :account => larkin_account,
    :name => "Wolfpack 2",
    :description => "5 days per week, office",
    :amount => "250.00",
    :billing_cycle => "Monthly",
    :billing_interval => "1",
    :trial_period_days => 30,
    :terms_and_conditions => "Be cool",
    :public => false
})
wolfpack_5_plan = Plan.create!({
    :account => larkin_account,
    :name => "Wolfpack 2",
    :description => "5 days per week, everything",
    :amount => "250.00",
    :billing_cycle => "Monthly",
    :billing_interval => "1",
    :trial_period_days => 30,
    :terms_and_conditions => "Be cool",
    :public => true
})

wolfpack_plans = [wolfpack_1_plan, wolfpack_2_plan, wolfpack_3_plan, wolfpack_4_plan, wolfpack_5_plan]

for i in 0..250
username = Faker::Name.name
email_address = Faker::Internet.safe_email

Subscription.create!({
  :account => Account.create!({
    :user => User.create!({
      :email => email_address,
      :password => Faker::Internet.password()
    }),
    :first_name => username.split(" ")[0],
    :last_name => username.split(" ")[1],
    :company_name => ""
  }),
  :plan => wolfpack_plans[rand(0..4)],
  #:account_payment_method =>
  :status => "Active"
})
end

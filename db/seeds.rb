# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')

valid_credit_card_nums = [
  "4242424242424242",
  "4012888888881881",
  "4000056655665556",
  "5555555555554444",
  "5200828282828210",
  "5105105105105100",
  "378282246310005",
  "371449635398431",
  "6011111111111117",
  "6011000990139424",
  "30569309025904",
  "38520000023237",
  "3530111333300000",
  "3566002020360505"
]
payment_processor = PaymentProcessor.create!({
  :name => "Stripe",
  :active => true
})
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
baby_moose = CreatePlan.call({
    :account => mm_account,
    :name => "Baby Moose",
    :stripe_id => "Test Baby Moose",
    :description => "Unlimited plans but only 5 subscribers per plan",
    :amount => 0,
    :billing_cycle => "month",
    :billing_interval => "1",
    :trial_period_days => 0,
    :terms_and_conditions => "Be cool"
}, ENV["STRIPE_SECRET_KEY"])
big_moose = CreatePlan.call({
    :account => mm_account,
    :name => "StartUp Moose",
    :stripe_id => "Test StartUp Moose",
    :description => "Unlimited plans up to 100 subscribers per plan",
    :amount => "9.99",
    :billing_cycle => "month",
    :billing_interval => "1",
    :trial_period_days => 30,
    :terms_and_conditions => "Be cool"
}, ENV["STRIPE_SECRET_KEY"])
baby_moose = CreatePlan.call({
    :account => mm_account,
    :name => "Top Moose",
    :stripe_id => "Top Moose",
    :description => "Unlimited plans, unlimited subscribers",
    :amount => "29.99",
    :billing_cycle => "month",
    :billing_interval => "1",
    :trial_period_days => 30,
    :terms_and_conditions => "Be cool"
}, ENV["STRIPE_SECRET_KEY"])
mama_moose = CreatePlan.call({
    :account => mm_account,
    :name => "Mama Moose",
    :stripe_id => "Mama Moose",
    :description => "Unlimited plans, unlimited subscribers but only if you're a mama moose",
    :amount => "19.99",
    :billing_cycle => "month",
    :billing_interval => "1",
    :trial_period_days => 30,
    :terms_and_conditions => "Be cool"
}, ENV["STRIPE_SECRET_KEY"])
papa_moose = CreatePlan.call({
    :account => mm_account,
    :name => "Papa Moose",
    :stripe_id => "Papa Moose",
    :description => "Unlimited plans, unlimited subscribers but only if you're a papa moose",
    :amount => "299.99",
    :billing_cycle => "month",
    :billing_interval => "1",
    :trial_period_days => 30,
    :terms_and_conditions => "Be cool"
}, ENV["STRIPE_SECRET_KEY"])
enterprise_moose = CreatePlan.call({
    :account => mm_account,
    :name => "Enterprise Moose",
    :stripe_id => "Enterprise Moose",
    :description => "Unlimited plans, unlimited subscribers for enterprise",
    :amount => "1000.99",
    :billing_cycle => "month",
    :billing_interval => "1",
    :trial_period_days => 30,
    :terms_and_conditions => "Be cool"
}, ENV["STRIPE_SECRET_KEY"])
special_moose = CreatePlan.call({
    :account => mm_account,
    :name => "Special Moose",
    :stripe_id => "Special Moose",
    :description => "Unlimited plans, unlimited subscribers for specials",
    :amount => "0.99",
    :billing_cycle => "month",
    :billing_interval => "1",
    :trial_period_days => 30,
    :terms_and_conditions => "Be cool"
}, ENV["STRIPE_SECRET_KEY"])
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

card = {
  number: valid_credit_card_nums[rand(0..valid_credit_card_nums.length-1)],
  brand: "Visa",
  expiration_month: rand(1..12),
  expiration_year: 2020,
  cvc: rand(100..999)
}
token = CreateToken.call(card[:number],
  card[:expiration_month],
  card[:expiration_year],
  card[:cvc],
  ENV["STRIPE_SECRET_KEY"])

CreateSubscription.call(
  special_moose,
  larkin_account.first_name,
  larkin_account.last_name,
  larkin_account.user.email,
  token.id,
  token.card.id,
  token.card.brand,
  token.card.last4,
  token.card.exp_month,
  token.card.exp_year
)

wolfpack_1_plan = CreatePlan.call({
    :account => larkin_account,
    :name => "Wolfpack 1",
    :stripe_id => "Test Wolfpack 1",
    :description => "1 day per week",
    :amount => "50.00",
    :billing_cycle => "month",
    :billing_interval => "1",
    :trial_period_days => 30,
    :terms_and_conditions => "Be cool",
    :public => true
}, ENV["STRIPE_SECRET_KEY"])
wolfpack_2_plan = CreatePlan.call({
    :account => larkin_account,
    :name => "Wolfpack 2",
    :stripe_id => "Test Wolfpack 2",
    :description => "3 days per week",
    :amount => "125.00",
    :billing_cycle => "month",
    :billing_interval => "1",
    :trial_period_days => 30,
    :terms_and_conditions => "Be cool",
    :public => true
}, ENV["STRIPE_SECRET_KEY"])
wolfpack_3_plan = CreatePlan.call({
    :account => larkin_account,
    :name => "Wolfpack 3",
    :stripe_id => "Test Wolfpack 3",
    :description => "5 days per week",
    :amount => "200.00",
    :billing_cycle => "month",
    :billing_interval => "1",
    :trial_period_days => 0,
    :terms_and_conditions => "Be cool",
    :public => true
}, ENV["STRIPE_SECRET_KEY"])
wolfpack_4_plan = CreatePlan.call({
    :account => larkin_account,
    :name => "Wolfpack 4",
    :stripe_id => "Test Wolfpack 4",
    :description => "5 days per week, office",
    :amount => "250.00",
    :billing_cycle => "month",
    :billing_interval => "1",
    :trial_period_days => 0,
    :terms_and_conditions => "Be cool",
    :public => false
}, ENV["STRIPE_SECRET_KEY"])
wolfpack_5_plan = CreatePlan.call({
    :account => larkin_account,
    :name => "Wolfpack 5",
    :stripe_id => "Test Wolfpack 5",
    :description => "5 days per week, everything",
    :amount => "250.00",
    :billing_cycle => "month",
    :billing_interval => "1",
    :trial_period_days => 0,
    :terms_and_conditions => "Be cool",
    :public => true
}, ENV["STRIPE_SECRET_KEY"])

wolfpack_plans = [wolfpack_1_plan, wolfpack_2_plan, wolfpack_3_plan, wolfpack_4_plan, wolfpack_5_plan]

for i in 0..250
  username = Faker::Name.name
  email_address = Faker::Internet.safe_email

  account = Account.create!({
    :user => User.create!({
      :email => email_address,
      :password => Faker::Internet.password()
    }),
    :first_name => username.split(" ")[0],
    :last_name => username.split(" ")[1],
    :company_name => ""
  })

  token = CreateToken.call(valid_credit_card_nums[rand(0..valid_credit_card_nums.length-1)], rand(1..12), 2020, rand(100..999), ENV["STRIPE_SECRET_KEY"])
  plan = wolfpack_plans[rand(0..4)]

  card = {
    :number => valid_credit_card_nums[rand(0..valid_credit_card_nums.length-1)],
    :brand => "Visa",
    :expiration_month => rand(1..12),
    :expiration_year => 2020,
    :cvc => rand(100..999)
  }
  token = CreateToken.call(card[:number],
    card[:expiration_month],
    card[:expiration_year],
    card[:cvc],
    ENV["STRIPE_SECRET_KEY"])

  account, subscription, card, raw_token = CreateSubscription.call(
    plan,
    account.first_name,
    account.last_name,
    account.user.email,
    token.id,
    token.card.id,
    token.card.brand,
    token.card.last4,
    token.card.exp_month,
    token.card.exp_year
  )

end

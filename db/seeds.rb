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
mm_free_plan = CreatePlan.call({
    :account => mm_account,
    :name => "Free Plan",
    :stripe_id => "MM Free Plan",
    :description => "Unlimited plans but only 5 subscribers per plan",
    :amount => 0,
    :billing_cycle => "month",
    :billing_interval => "1",
    :trial_period_days => 0,
    :terms_and_conditions => "Be cool"
}, ENV["STRIPE_SECRET_KEY"])
mm_paid_plan = CreatePlan.call({
    :account => mm_account,
    :name => "Member Moose Awesomeness",
    :stripe_id => "MM Paid Plan",
    :description => "Unlimited plans, unlimited subscribers, unlimited members",
    :amount => "30.00",
    :billing_cycle => "month",
    :billing_interval => "1",
    :trial_period_days => 30,
    :terms_and_conditions => "Be cool"
}, ENV["STRIPE_SECRET_KEY"])

larkin_stripe_key = ENV["BULL_STRIPE_SECRET_KEY"]
larkin_account = Account.create!({
  :user => User.create!({
    :email => 'bull@membermoose.com',
    :password => 'password'
  }),
  :first_name => "Ima",
  :last_name => "Bull",
  :company_name => "IMA Bull LLC",
  :subdomain => "ima-bull",
  :site_url => (Rails.env.production? ? "https://ima-bull.membermoose-ng.com" : "http://ima-bull.mmoose-ng.localhost:3000/"),
  :has_connected_stripe => false
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
  mm_free_plan,
  larkin_account.first_name,
  larkin_account.last_name,
  larkin_account.user.email,
  token.id,
  token.card.id,
  token.card.brand,
  token.card.last4,
  token.card.exp_month,
  token.card.exp_year,
  ENV["STRIPE_SECRET_KEY"]
)

coworking_fulltime_plan = CreatePlan.call({
    :account => larkin_account,
    :name => "Coworking Wolfpack",
    :stripe_id => "Coworking Wolfpack",
    :description => "Full Time",
    :amount => "250.00",
    :billing_cycle => "month",
    :billing_interval => "1",
    :trial_period_days => 30,
    :terms_and_conditions => "Be cool",
    :public => true
}, larkin_stripe_key)
coworking_community_plan = CreatePlan.call({
    :account => larkin_account,
    :name => "Coworking Community Member",
    :stripe_id => "Coworking Community Member",
    :description => "1 day per month",
    :amount => "35.00",
    :billing_cycle => "month",
    :billing_interval => "1",
    :trial_period_days => 0,
    :public => true
}, larkin_stripe_key)
coworking_lone_wolf_plan = CreatePlan.call({
    :account => larkin_account,
    :name => "Coworking Lone Wolf",
    :stripe_id => "Coworking Lone Wolf",
    :description => "3 days per week",
    :amount => "175.00",
    :billing_cycle => "month",
    :billing_interval => "1",
    :trial_period_days => 0,
    :public => true
}, larkin_stripe_key)

wolfpack_plans = [
  coworking_fulltime_plan,
  coworking_community_plan,
  coworking_lone_wolf_plan
]
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

  token = CreateToken.call(valid_credit_card_nums[rand(0..valid_credit_card_nums.length-1)],
    rand(1..12), 2020,
    rand(100..999),
    larkin_stripe_key)
  plan = wolfpack_plans[rand(0..2)]

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
    larkin_stripe_key)

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
    token.card.exp_year,
    larkin_stripe_key
  )

end

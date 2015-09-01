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
    :trail_period_days => 0,
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

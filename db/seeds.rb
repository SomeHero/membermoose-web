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
  :company_name => "Member Moose",
  :role => Account.roles[:bull]
  #logo =>
})
mm_account.bull = mm_account
mm_account.save

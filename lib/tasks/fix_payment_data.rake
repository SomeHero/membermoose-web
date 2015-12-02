desc "Fix Payment Data"
task :fix_payment_Data=> [:environment] do
  accounts = Account.where(:role => Account.roles[:bull])

  puts "Found #{accounts.count} account"
  accounts.each do |account|
    puts "Found #{account.payments.count} payments"
    account.payments.each do |payment|
      begin
        payment.payee = payment.subscription.account
        payment.save
      rescue
        #do nothing
        puts "Failed saving payment"
      end
    end
  end
end

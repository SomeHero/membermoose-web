desc "Fix Payment Data"
task :fix_payment_Data=> [:environment] do
  accounts = Account.where(:role => Account.roles[:bull])

  accounts.each do |account|
    account.payments.each do |payment|
      begin
        payment.payee = payment.subscription
        payment.save
      rescue
        #do nothing
      end
    end
  end
end

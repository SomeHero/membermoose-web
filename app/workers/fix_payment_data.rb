require 'slack-notifier'

class FixPaymentDataWorker
  @queue = :fix_payment_date_worker_queue

  def self.perform()

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

end

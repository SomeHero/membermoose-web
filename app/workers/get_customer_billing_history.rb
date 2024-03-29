require 'slack-notifier'

class GetCustomerBillingHistoryWorker
  @queue = :get_customer_billing_history_worker_queue

  def self.perform(subscription_id)
    subscription = Subscription.find(subscription_id)
    account = subscription.plan.account

    stripe_customer_id = subscription.account.stripe_customer_id
    results = GetCharges.call(stripe_customer_id, subscription.plan.account.stripe_secret_key)

    if !results[0]
      Rails.logger.error "Error Getting Charges #{results[1]}"

      raise "Error Getting Charges #{results[1]}"
    end

    stripe_charges = results[1]

    stripe_charges.each do |stripe_charge|
      stripe_charge_id = stripe_charge["id"]
      stripe_card_id = stripe_charge["source"]["id"]
      stripe_invoice_id = stripe_charge["invoice"]
      stripe_balance_txn_id = stripe_charge["balance_transaction"]
      stripe_payment_processor = PaymentProcessor.where(:name => "Stripe").first

      results = GetBalanceTransaction.call(stripe_balance_txn_id, account.stripe_secret_key)

      if results[0]
        stripe_balance_txn = results[1]
      else
        Rails.logger.info "Unable to get balance transaction #{stripe_balance_txn_id}: #{results[1]}"
      end
      results = GetInvoice.call(stripe_invoice_id, account.stripe_secret_key)

      if results[0]
        stripe_invoice = results[1]
      else
        Rails.logger.info "Unable to get invoice #{stripe_invoice_id}: #{results[1]}"
      end

      card = account.cards.find_by_external_id(stripe_card_id)
      charge = Charge.find_by_external_id(stripe_charge_id)

      next if charge

      Payment.create!({
        :charge => Charge.new({
          :external_id => stripe_charge_id,
          :external_invoice_id => stripe_invoice["id"],
          :status => stripe_charge["status"],
          :amount => Money.new(stripe_charge["amount"], "USD").cents.to_f/100,
          :currency => stripe_charge["currency"],
          :card => card
        }),
        :payment_processor => stripe_payment_processor,
        :account => subscription.plan.account,
        :payee => account,
        :amount => Money.new(stripe_balance_txn["amount"], "USD").cents.to_f/100,
        :transaction_date => Time.at(stripe_charge["created"]),
        :payment_processor_fee => Money.new(stripe_balance_txn["fee"], "USD").cents.to_f/100,
        :payment_method => "Credit Card",
        :payment_type => "Recurring",
        :status => "Paid",
        :subscription => subscription,
        :card => card,
        :comments => "Recurring Payment for #{subscription.plan.name} (test)"
      })

      invoice = Invoice.find_by_external_id(stripe_invoice_id)

      next if invoice

      invoice = Invoice.create!({
        :external_id => stripe_invoice["id"],
        :total => Money.new(stripe_invoice["total"], "USD").cents.to_f/100,
        :subtotal => Money.new(stripe_invoice["subtotal"], "USD").cents.to_f/100,
        :due_date => Time.at(stripe_invoice["date"]),
        :subscription => subscription,
        :status => "Paid"
      })
    end
  end
end

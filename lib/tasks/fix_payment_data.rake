desc "Fix Payment Data"
task :fix_payment_data=> [:environment] do
  accounts = Account.where(:role => Account.roles[:bull])

  puts "Found #{accounts.count} account"
  accounts.each do |account|
    puts "Found #{account.plans.count} Plans"
    account.plans.each do |plan|
      puts "Starting account #{account.company_name}"
      plan.subscriptions.each do |subscription|

        stripe_customer_id = subscription.account.stripe_customer_id
        stripe_charges = GetCharges.call(stripe_customer_id, subscription.plan.account.stripe_secret_key)

        puts "Found #{stripe_charges.count} stripe charges"

        stripe_charges.each do |stripe_charge|
          #puts "Stripe Charge: #{stripe_charge}"
          #puts stripe_charge.to_json

          begin
            stripe_charge_id = stripe_charge["id"]

            stripe_card_id = stripe_charge["source"]["id"]
            stripe_invoice_id = stripe_charge["invoice"]
            stripe_balance_txn_id = stripe_charge["balance_transaction"]
            stripe_payment_processor = PaymentProcessor.where(:name => "Stripe").first

            stripe_balance_txn = GetBalanceTransaction.call(stripe_balance_txn_id, account.stripe_secret_key)
            stripe_invoice = GetInvoice.call(stripe_invoice_id, subscription.plan.account.stripe_secret_key)
            stripe_source = stripe_charge["source"]

            card = account.cards.find_by_external_id(stripe_source["id"])

            if !card
              puts "creating a new card"

              card = Card.new({
                  :account => subscription.plan.account,
                  :external_id => stripe_source["id"],
                  :name_on_card => stripe_source["name"],
                  :brand => stripe_source["brand"],
                  :last4 => stripe_source["last4"],
                  :expiration_month => stripe_source["exp_month"],
                  :expiration_year => stripe_source["exp_year"]
              })
            else
              puts "updating a card"

              card.account = subscription.plan.account
              card.name_on_card = stripe_source["name"]
              card.brand = stripe_source["brand"]
              card.last4 = stripe_source["last4"]
              card.expiration_month = stripe_source["exp_month"]
              card.expiration_year = stripe_source["exp_year"]

              card.save
            end
            charge = Charge.find_by_external_id(stripe_charge_id)

            payment = charge.payment

            if !payment
              puts "Creating a payment for charge #{stripe_charge_id}"

              status = "Paid"
              comment = "Recurring Payment for #{subscription.plan.name}"
              if !stripe_charge["paid"]
                status = "Failed"
                comment = "#{subscription["failure_code"]}: #{subscription["failure_message"]}"
              end

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
                :payee => subscription.account,
                :amount => Money.new(stripe_balance_txn["amount"], "USD").cents.to_f/100,
                :transaction_date => Time.at(stripe_charge["created"]),
                :payment_processor_fee => Money.new(stripe_balance_txn["fee"], "USD").cents.to_f/100,
                :payment_method => "Credit Card",
                :payment_type => "Recurring",
                :status => status,
                :subscription => subscription,
                :card => card,
                :comments => comment
              })
            else
              puts "Updating a payment for charge #{stripe_charge_id}"

              payment = charge.payment
              payment.transaction_date = Time.at(stripe_charge["created"])
              payment.payee = subscription.account
              payment.card = card
              payment.status = status
              payment.comments = comment

              payment.save
            end

            invoice = Invoice.find_by_external_id(stripe_invoice_id)

            if !invoice
              puts "Creating an invoice for invoice #{stripe_invoice["id"]}"
              puts stripe_invoice.to_json

              invoice = Invoice.create!({
                :external_id => stripe_invoice["id"],
                :total => Money.new(stripe_invoice["total"], "USD").cents.to_f/100,
                :subtotal => Money.new(stripe_invoice["subtotal"], "USD").cents.to_f/100,
                :due_date => Time.at(stripe_invoice["date"]),
                :subscription => subscription,
                :status => status
              })
            end
          rescue => e
            puts "Error #{e} #{e.backtrace} "
          end
        end
      end
    end
  end
end

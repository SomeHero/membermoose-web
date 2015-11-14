StripeEvent.event_retriever = lambda do |params|
  return nil if StripeWebhook.exists?(stripe_id: params[:id])
  StripeWebhook.create!(stripe_id: params[:id])
  Stripe::Event.retrieve(params[:id])
end

StripeEvent.configure do |events|
  #account.updated
  #account.application.deauthorized
  #account.external_account.created
  #account.external_account.deleted
  #account.external_account.updated
  #application_fee.created
  #application_fee.refunded
  #application_fee.refund.updated
  #balance.available
  #bitcoin.receiver.created
  #bitcoin.receiver.filled
  #bitcoin.receiver.updated
  #bitcoin.receiver.transaction.created
  #charge.captured
  #charge.failed
  #charge.refunded
  #charge.succeeded
  #charge.updated
  #charge.dispute.closed
  #charge.dispute.created
  #charge.dispute.funds_reinstated
  #charge.dispute.funds_withdrawn
  #charge.dispute.updated
  #coupon.created
  #coupon.deleted
  #coupon.updated
  #customer.created
  #customer.deleted
  #customer.updated
  #customer.discount.created
  #customer.discount.deleted
  #customer.discount.updated
  #customer.source.created
  #customer.source.deleted
  #customer.source.updated
  #customer.subscription.created
  #customer.subscription.delete
  #customer.subscription.trial_will_end
  #customer.subscription.updated
  #invoice.created
  #invoice.payment_failed
  #invoice.payment_succeeded
  #invoice.updated
  #invoiceitem.created
  #invoiceitem.deleted
  #invoiceitem.updated
  #order.created
  #order.payment_failed
  #order.payment_succeeded
  #order.updated
  #plan.created
  #plan.deleted
  #plan.updated
  #product.created
  #product.updated
  #recipient.created
  #recipient.deleted
  #recipient.updated
  #sku.created
  #sku.updated
  #transfer.created
  #transfer.failed
  #transfer.paid
  #transfer.reversed
  #transfer.updated
  #ping

  events.subscribe 'customer.created' do |event|
    Rails.logger.debug "Received customer.created stripe-event"

  end
  events.subscribe 'customer.subscription.created' do |event|
    Rails.logger.debug "Received subscription.created stripe-event"

  end
  events.subscribe 'invoice.created' do |event|
    Rails.logger.debug "Received invoice.created stripe-event"

    invoice = event.data.object
    subscription = Subscription.find_by(:stripe_id => invoice.subscription)

    status = "Unpaid"
    if subscription.payments.count > 0
      status = "Paid"
    end
    new_invoice = subscription.invoices.create!({
        :external_id => invoice.id,
        :total => invoice.total.to_f/100,
        :subtotal => invoice.subtotal.to_f/100,
        :subscription => subscription,
        :status => status
    })

    begin
      Resque.enqueue(InvoiceCreatedWorker, new_invoice.id)
    rescue
      puts "Error #{$!}"
    end

  end
  events.subscribe 'invoice.payment_succeeded' do |event|
    stripe_payment_processor = PaymentProcessor.where(:name => "Stripe").first

    stripe_invoice = event.data.object
    invoice = Invoice.find_by(external_id: stripe_invoice.id)
    account = Account.find_by(stripe_customer_id: stripe_invoice.customer)

    invoice_sub = stripe_invoice.lines.data.select { |i| i.type == 'subscription' }.first.id
    subscription = Subscription.find_by(stripe_id: invoice_sub)

    stripe_charge = Stripe::Charge.retrieve(stripe_invoice.charge)
    card = card = Card.find_by(:external_id => stripe_charge.source.id)
    stripe_balance_txn = Stripe::BalanceTransaction.retrieve(stripe_charge.balance_transaction)

    Payment.create!({
        :charge => Charge.create!({
          :external_id => stripe_charge.id,
          :external_invoice_id => stripe_invoice.id,
          :status => stripe_charge.status,
          :amount => stripe_charge.amount.to_f/100,
          :currency => stripe_charge.currency,
          :card => card
        }),
        :payment_processor => stripe_payment_processor,
        :account => subscription.plan.account,
        :payee => account,
        :amount => stripe_invoice.total.to_f/100,
        :payment_processor_fee => stripe_balance_txn.fee.to_f/100,
        :payment_method => "Credit Card",
        :payment_type => "Recurring",
        :status => "Paid",
        :subscription => subscription,
        :card => card,
        :comments => "Recurring Payment for #{subscription.plan.name} (test)"
    })
    if invoice
      invoice.status = "Paid"
      invoice.save
    end

    #let's request the next invoice on a worker
    begin
      Resque.enqueue(GetNextCustomerInvoiceWorker, subscription.id)
    rescue
      puts "Error #{$!}"
    end

  end
  events.subscribe 'charge.dispute.created' do |event|
    charge = event.data.object
    invoice = Invoice.find_by(external_id: invoice)
    payment = Payment.find_by(external_id: charge.id)

    if payment
      begin
        Resque.enqueue(ChargeDisputedWorker, payment.id)
      rescue
        puts "Error #{$!}"
      end
    else
      #generate an alert as we don't know how to handle
    end
  end
  events.subscribe 'charge.succeeded' do |event|
    Rails.logger.debug "Received charge.succeeded stripe-event"

    data = event.data.object

    card = Card.find_by(:external_id => data.source.id)

    charge = Charge.create!({
      :external_id => data.id,
      :external_invoice_id => data.invoice,
      :status => data.status,
      :amount => data.amount.to_f/100,
      :currency => data.currency,
      :card => card
    })

    begin
      Resque.enqueue(ChargeSucceededWorker, charge.id)
    rescue
      Rails.logger.debug "Error processing charge.succeeded stripe-event: #{$!}"
    end
  end
  events.subscribe 'charge.failed' do |event|
    # Define subscriber behavior based on the event object
    #event.class       #=> Stripe::Event
    #event.type        #=> "charge.failed"
    data = event.data.object #=> #<Stripe::Charge:0x3fcb34c115f8>
    charge = Charge.find_by(external_id: data.id)

    begin
      Resque.enqueue(ChargeFailedWorker, charge.id)
    rescue
      puts "Error #{$!}"
    end
  end
  events.subscribe 'charge.refunded' do |event|
    # Define subscriber behavior based on the event object
    #event.class       #=> Stripe::Event
    #event.type        #=> "charge.failed"
    charge = event.data.object #=> #<Stripe::Charge:0x3fcb34c115f8>
    payment = Payment.find_by(external_id: charge.id)

    begin
      Resque.enqueue(ChargeRefundedWorker, payment.id)
    rescue
      puts "Error #{$!}"
    end
  end

end

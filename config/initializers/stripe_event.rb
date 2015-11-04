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

    new_invoice = subscription.invoices.create!({
        :external_id => invoice.id,
        :total => invoice.total/100,
        :subtotal => invoice.subtotal/100,
        :subscription => subscription,
        :status => "Unpaid"
    })

    begin
      Resque.enqueue(InvoiceCreatedWorker, new_invoice.id)
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

    binding.pry
    data = event.data.object

    if data.card
      card = Card.find_by(:external_id => data.card.id)
    end
    
    charge = Charge.create!({
      :external_id => data.id,
      :external_invoice_id => data.invoice,
      :status => data.status,
      :amount => data.amount/100,
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

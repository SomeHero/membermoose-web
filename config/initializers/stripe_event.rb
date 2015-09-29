StripeEvent.event_retriever = lambda do |params|
  return nil if StripeWebhook.exists?(stripe_id: params[:id])
  StripeWebhook.create!(stripe_id: params[:id])
  Stripe::Event.retrieve(params[:id])
end

StripeEvent.configure do |events|
  events.subscribe 'charge.dispute.created' do |event|
    charge = event.data.object
    payment = Payment.find_by(external_id: charge_id)

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
    charge = event.data.object
    begin
      Resque.enqueue(ChargeSucceededWorker, payment.id)
    rescue
      puts "Error #{$!}"
    end
  end
  events.subscribe 'charge.failed' do |event|
    # Define subscriber behavior based on the event object
    #event.class       #=> Stripe::Event
    #event.type        #=> "charge.failed"
    charge = event.data.object #=> #<Stripe::Charge:0x3fcb34c115f8>

    begin
      Resque.enqueue(ChargeFailedWorker, payment.id)
    rescue
      puts "Error #{$!}"
    end
  end

end

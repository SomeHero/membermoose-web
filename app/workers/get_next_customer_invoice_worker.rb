require 'slack-notifier'

class GetNextCustomerInvoiceWorker

  @queue = :get_next_customer_invoice_worker_queue

  def self.perform(subscription_id)
    binding.pry
    
    subscription = Subscription.find(subscription_id)
    bull_account = subscription.plan.account

    stripe_payment_processor = PaymentProcessor.where(:name => "Stripe").first
    stripe = bull_account.account_payment_processors.where(:payment_processor => stripe_payment_processor).active.first

    GetUpcomingInvoice.call(subscription, stripe.secret_token)
  end
end

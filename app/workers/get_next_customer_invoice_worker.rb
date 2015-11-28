require 'slack-notifier'

class GetNextCustomerInvoiceWorker

  @queue = :get_next_customer_invoice_worker_queue

  def self.perform(subscription_id)
    subscription = Subscription.find(subscription_id)
    bull_account = subscription.plan.account

    GetUpcomingInvoice.call(subscription)
  end
end

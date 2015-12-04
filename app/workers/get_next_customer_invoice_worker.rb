require 'slack-notifier'

class GetNextCustomerInvoiceWorker

  @queue = :get_next_customer_invoice_worker_queue

  def self.perform(subscription_id)
    subscription = Subscription.find(subscription_id)

    result = GetUpcomingInvoice.call(subscription)

    if !result[0]
      raise "Error Getting Upcoming Invoices #{results[1]}"
    end
  end
end

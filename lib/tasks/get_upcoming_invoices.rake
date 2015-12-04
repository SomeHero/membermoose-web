desc "Get Upcoming Invoices"
task :get_upcoming_invoices => [:environment] do
  subscriptions = Subscription.all
  puts "Found #{subscriptions.count} subscriptions"

  plan.subscriptions.each do |subscription|
    results = GetUpcomingInvoice.call(subscription)

    if !results[0]
      Rails.logger.error "Error Getting Upcoming Invoice #{results[1]}"
    end  
  end
end

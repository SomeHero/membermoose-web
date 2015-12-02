require 'money'

class GetUpcomingInvoice
  def self.call(subscription)
    stripe_secret_key = subscription.plan.account.bull.stripe_secret_key
    stripe_customer_id = subscription.account.stripe_customer_id

    return false if !stripe_secret_key
    return false if !stripe_customer_id

    begin
      Stripe.api_key = stripe_secret_key

      stripe_invoice = Stripe::Invoice.upcoming(:customer => stripe_customer_id)
    rescue Stripe::StripeError => e
      subscription.errors[:base] << e.message
      return subscription
    end

    new_invoice = Invoice.new({
        :external_id => "",
        :total => Money.new(stripe_invoice.total, "USD").cents.to_f/100,
        :subtotal => Money.new(stripe_invoice.subtotal, "USD").cents.to_f/100,
        :due_date => Time.at(stripe_invoice.date),
        :subscription => subscription,
        :status => "Unpaid"
    })

    if new_invoice.valid?
      Invoice.delete_all(:subscription => subscription, :external_id => "")

      new_invoice.save
    end

    return new_invoice
  end
end

require 'money'

class CreatePlan
  def self.call(options={}, stripe_secret_key)

    plan = Plan.new(options)
    #ToDo: Add something that indicates weather this is synced

    if !plan.valid?
      return plan
    end
    if !stripe_secret_key
      plan.needs_sync = true
      plan.save #just go ahead and save the plan unsync'ed
      return plan
    end

    begin
      Stripe.api_key =  stripe_secret_key

      amount = Money.from_amount(options[:amount].to_f, "USD")

      Stripe::Plan.create(
        id: options[:stripe_id],
        amount: amount.cents,
        currency: 'usd',
        interval: options[:billing_cycle],
        interval_count: options[:billing_interval],
        name: options[:name]
      )
    rescue Stripe::StripeError => e
      plan.errors[:base] << e.message
      return plan
    end

    #ToDo: if we got this far update flag to incidate plan was synced
    plan.save

    return plan
  end
end

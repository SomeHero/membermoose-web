require 'money'

class CreatePlan
  def self.call(account, options={})
    plan = Plan.new(options)

    if !plan.valid?
      return plan
    end
    if !account.has_connected_stripe
      plan.needs_sync = true
      plan.save #just go ahead and save the plan unsync'ed
      return plan
    end

    stripe_secret_key = account.stripe_secret_key

    return false if !stripe_secret_key
    begin
      Stripe.api_key =  stripe_secret_key

      amount = Money.from_amount(options[:amount].to_f, "USD")

      Stripe::Plan.create(
        id: options[:stripe_id],
        amount: amount.cents,
        currency: 'usd',
        interval: options[:billing_cycle],
        interval_count: options[:billing_interval],
        name: options[:name],
        trial_period_days: options["trial_period_days"] || 0
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

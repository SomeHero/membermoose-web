require 'money'

class CreatePlan
  def self.call(account, options={}, coupon_options={})
    plan = Plan.new(options)

    if coupon_options
      results = CreateCoupon.call(account, coupon_options)

      return false, results[1] if !results[0]

      coupon = results[1]
    end

    return false, plan if !plan.valid?

    if !account.has_connected_stripe
      plan.needs_sync = true
      plan.save #just go ahead and save the plan unsync'ed
      return true, plan, coupon
    end

    stripe_secret_key = account.stripe_secret_key

    return false, "Stripe key not provided" if !stripe_secret_key

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
      return false, e.message
    end

    return true, plan, coupon
  end
end

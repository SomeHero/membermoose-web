require 'money'

class SyncPlan
  def self.call(plan, stripe_secret_key)

    begin
      Stripe.api_key =  stripe_secret_key

      amount = Money.from_amount(plan.amount.to_f, "USD")

      Stripe::Plan.create(
        id: plan.stripe_id,
        amount: amount.cents,
        currency: 'usd',
        interval: plan.billing_cycle,
        interval_count: plan.billing_interval,
        name: plan.name
      )
    rescue Stripe::StripeError => e
      plan.errors[:base] << e.message
      return plan
    end

    plan.needs_sync = false
    plan.save

    return plan
  end
end

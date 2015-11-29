require 'money'

class UpdatePlan
  def self.call(plan)
    stripe_secret_key = plan.account.stripe_secret_key
    amount = Money.from_amount(plan.amount.to_f, "USD")

    binding.pry
    begin
      Stripe.api_key =  stripe_secret_key

      stripe_plan = Stripe::Plan.retrieve(plan.stripe_id)
      stripe_plan.amount = amount.cents
      stripe_plan.interval = plan.billing_cycle
      stripe_plan.interval_count = plan.billing_interval
      stripe_plan.name = plan.name
      stripe_plan.trial_period_days = plan.trial_period_days

      stripe_plan.save
    rescue Stripe::StripeError => e
      plan.errors[:base] << e.message
      return plan
    end
  end
end

class GetPlan
  def self.call(plan_id, stripe_secret_key)

    begin
      Stripe.api_key =  stripe_secret_key

      plan = Stripe::Plan.retrieve(plan_id)
    rescue Stripe::StripeError => e
      return e.message
    end

    return plan.data
  end
end

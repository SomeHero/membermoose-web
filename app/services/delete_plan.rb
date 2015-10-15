class DeletePlan
  def self.call(plan, stripe_secret_key)

    begin
      Stripe.api_key =  stripe_secret_key

      stripe_plan = Stripe::Plan.retrieve(plan.stripe_id)
      stripe_plan.delete

    rescue Stripe::StripeError => e
      plan.errors[:base] << e.message
      return plan
    end

    return plan
  end
end

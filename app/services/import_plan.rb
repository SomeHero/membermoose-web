class ImportPlan
  def self.call(account, stripe_id, stripe_secret_key)
    begin
      Stripe.api_key =  stripe_secret_key

      stripe_plan = Stripe::Plan.retrieve(stripe_id)
    rescue Stripe::StripeError => e
      return e.message
    end

    plan = Plan.new({
        :account => account,
        :name => stripe_plan["name"],
        :stripe_id => stripe_plan["id"],
        :amount => stripe_plan["amount"],
        :billing_cycle => "month",
        :billing_interval => 1,
        :trial_period_days => 0,
        :public => true
    })

    return plan
  end
end

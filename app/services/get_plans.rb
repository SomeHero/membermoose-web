class GetPlans
  def self.call(options={}, stripe_secret_key)

    begin
      Stripe.api_key =  stripe_secret_key

      plans = Stripe::Plan.all(:limit => 100)
    rescue Stripe::StripeError => e
      return e.message
    end

    return plans.data
  end
end

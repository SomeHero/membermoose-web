class GetPlans
  def self.call(options={}, stripe_secret_key)

    binding.pry
    begin
      Stripe.api_key =  stripe_secret_key

      plans = Stripe::Plan.all()
    rescue Stripe::StripeError => e
      return e.message
    end

    return plans
  end
end

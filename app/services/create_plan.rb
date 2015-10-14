class CreatePlan
  def self.call(options={}, stripe_secret_key)
    plan = Plan.new(options)

    if !plan.valid?
      return plan
    end

    begin
      Stripe.api_key =  stripe_secret_key

      Stripe::Plan.create(
        id: options[:stripe_id],
        amount: (options[:amount].to_f * 100).to_i,
        currency: 'usd',
        interval: options[:billing_cycle],
        interval_count: options[:billing_interval],
        name: options[:name]
      )
    rescue Stripe::StripeError => e
      plan.errors[:base] << e.message
      return plan
    end

    plan.save

    return plan
  end
end

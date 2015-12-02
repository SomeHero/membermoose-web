class ChangeSubscription
  def self.call(subscription, plan)
    stripe_secret_key = subscription.plan.account.stripe_secret_key
    stripe_customer_id = subscription.account.stripe_customer_id
    stripe_subscription_id = subscription.stripe_id
    stripe_plan_id = plan.stripe_id

    return false if !stripe_secret_key
    return false if !stripe_customer_id
    return false if !stripe_subscription_id
    return false if !stripe_plan_id

    begin
      Stripe.api_key = stripe_secret_key

      customer = Stripe::Customer.retrieve(stripe_customer_id)
      stripe_subscription = customer.subscriptions.retrieve(stripe_subscription_id)

      stripe_subscription.plan = stripe_plan_id
      stripe_subscription.save
    rescue Stripe::StripeError => e
      throw e
    end

    subscription.plan = plan
    subscription.save

    return subscription
  end
end

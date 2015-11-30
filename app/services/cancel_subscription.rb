class CancelSubscription
  def self.call(subscription)
    stripe_secret_key = subscription.account.stripe_secret_key
    stripe_customer_id = subscription.account.stripe_customer_id
    stripe_subscription_id = subscription.stripe_id

    binding.pry
    return false if !stripe_secret_key
    return false if !stripe_customer_id
    return false if !stripe_subscription_id

    begin
      Stripe.api_key =  stripe_secret_key

      customer = Stripe::Customer.retrieve(stripe_customer_id)
      customer.subscriptions.retrieve(stripe_subscription_id).delete
    rescue Stripe::StripeError => e
      throw e
    end

    subscription.status = Subscription.statuses[:cancelled]
    subscription.save

    return subscription
  end
end

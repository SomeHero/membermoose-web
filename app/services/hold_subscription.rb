class HoldSubscription
  def self.call(subscription)
    stripe_secret_key = subscription.plan.account.stripe_secret_key
    stripe_customer_id = subscription.account.stripe_customer_id
    stripe_subscription_id = subscription.stripe_id

    return false, "Stripe key not provided" if !stripe_secret_key
    return false, "Stripe customer id not provided" if !stripe_customer_id
    return false, "Stripe subscription id not provided" if !stripe_subscription_id

    begin
      Stripe.api_key =  stripe_secret_key

      customer = Stripe::Customer.retrieve(stripe_customer_id)
      customer.subscriptions.retrieve(stripe_subscription_id).delete
    rescue Stripe::StripeError => e
      Rails.logger.error "Error Cancelling a Subscription #{e.message}:#{e.backtrace}"

      return false, "Error Cancelling a Subscription #{e.message}"
      #throw e
    end

    subscription.status = Subscription.statuses[:hold]

    return true, subscription
  end
end

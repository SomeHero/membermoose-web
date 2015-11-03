class CancelSubscription
  def self.call(subscription)
    stripe_customer_id = subscription.account.stripe_customer_id
    stripe_subscription_id = subscription.stripe_id

    begin
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

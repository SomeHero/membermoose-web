class UnholdSubscription
  def self.call(subscription)
    stripe_secret_key = subscription.plan.account.stripe_secret_key
    stripe_customer_id = subscription.account.stripe_customer_id
    stripe_plan_id = subscription.plan.stripe_id

    return false, "Stripe key not provided" if !stripe_secret_key
    return false, "Stripe customer id not provided" if !stripe_customer_id
    return false, "Stripe plan id not provided" if !stripe_plan_id

    card = subscription.card

    return false, "No payment method associated with subscription" if !card
    begin
      Stripe.api_key =  stripe_secret_key

      customer = Stripe::Customer.retrieve(stripe_customer_id)
      return false, "Unable to find customer in Stripe" if !customer

      stripe_card = customer.sources.retrieve(card.external_id)
      return false, "Unable to find payment source for Stripe customer" if !stripe_card

      stripe_sub = customer.subscriptions.create(
        plan: stripe_plan_id
      )

    rescue Stripe::StripeError => e
      Rails.logger.error "Stripe Error Unholding a Subscription #{e.message}:#{e.backtrace}"

      return false, "Stripe Error Unholding a Subscription #{e.message}"
    rescue => e
      Rails.logger.error "Error Unholding a Subscription #{e.message}:#{e.backtrace}"

      return false, "Error Unholding a Subscription #{e.message}"
    end

    subscription.stripe_id = stripe_sub.id

    return true, subscription
  end
end

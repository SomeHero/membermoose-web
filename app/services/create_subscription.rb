class CreateSubscription
  def self.call(plan, email_address, token)
    account, raw_token = CreateUser.call(email_address)

    subscription = Subscription.new(
      plan: plan,
      account: account
    )

    begin
      stripe_sub = nil
      if account.stripe_customer_id.blank?
        customer = Stripe::Customer.create(
          source: token,
          email: account.user.email,
          plan: plan.stripe_id,
        )
        account.stripe_customer_id = customer.id
        account.save!

        stripe_sub = customer.subscriptions.first
      else
        customer = Stripe::Customer.retrieve(account.stripe_customer_id)
        stripe_sub = customer.subscriptions.create(
          plan: plan.stripe_id
        )
      end

      subscription.stripe_id = stripe_sub.id

      subscription.save!
    rescue Stripe::StripeError => e
      subscription.errors[:base] << e.message
    end

    subscription
  end
end

class CreateSubscription
  def self.call(plan, first_name, last_name, email_address, token,
    stripe_card_id, card_brand, card_last4, exp_month, exp_year, stripe_secret_key)

    account, raw_token = CreateUser.call(first_name, last_name, email_address)

    payment_processor = PaymentProcessor.find_by(:name => "Stripe")

    card = account.cards.where(:external_id => stripe_card_id).first

    if !card
      card = Card.create!({
          :account => account,
          :external_id => stripe_card_id,
          :brand => card_brand,
          :last4 => card_last4,
          :expiration_month => exp_month,
          :expiration_year => exp_year
      })
    end

    subscription = Subscription.new(
      plan: plan,
      account: account,
      card: card,
      status: Subscription.statuses[:subscribed]
    )

    begin
      Stripe.api_key =  stripe_secret_key

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

        subscription.stripe_id = stripe_sub.id

        #ToDo: create method on Plan that will calculate the next invoice date
        next_invoice_date = Date.today + 30.days
        subscription.save!
      else
        customer = Stripe::Customer.retrieve(account.stripe_customer_id)
        stripe_sub = customer.subscriptions.create(
          plan: plan.stripe_id
        )
      end
    rescue Stripe::StripeError => e
      subscription.errors[:base] << e.message

      return account, subscription, card, raw_token
    end

    return account, subscription, card, raw_token
  end
end

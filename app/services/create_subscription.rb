class CreateSubscription
  def self.call(plan, first_name, last_name, email_address, token,
    stripe_card_id, card_brand, card_last4, exp_month, exp_year)

    account, raw_token = CreateUser.call(first_name, last_name, email_address)

    #does card exist for account
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
      card: card
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

    return account, subscription, card, raw_token
  end
end

class CreateSubscription
  def self.call(plan, first_name, last_name, email_address, token,
    stripe_card_id, card_brand, card_last4, exp_month, exp_year)

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

      subscription.payments.new({
          :account => plan.account,
          :account_payment_processor => AccountPaymentProcessor.new({
            :account => account,
            :payment_processor => payment_processor,
            :active => true
          }),
          :amount => plan.amount,
          :payment_processor_fee => plan.amount*0.01+0.30,
          :payment_method => "Credit Card",
          :payment_type => "Recurring",
          :status => "Pending",
          :card => card,
          :comments => "Recurring Payment for #{subscription.plan.name} (test)"
      })

      subscription.stripe_id = stripe_sub.id
    rescue Stripe::StripeError => e
      subscription.errors[:base] << e.message

      return account, subscription, card, raw_token
    end

    subscription.save!

    return account, subscription, card, raw_token
  end
end

class SetCustomerDefaultCard

  def self.call(account, card)
    stripe_secret_key = account.bull.stripe_secret_key
    stripe_customer_id = card.account.stripe_customer_id

    card.dmr
      Stripe.api_key =  stripe_secret_key

      customer = Stripe::Customer.retrieve(stripe_customer_id)
      customer.default_source = card.external_id
      customer.save
    rescue Stripe::StripeError => e
      card.errors[:base] << e.message
      return card
    end

    return card
  end
end

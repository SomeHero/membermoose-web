class AddCard
  def self.call(account, stripe_token)
    stripe_secret_key = account.stripe_secret_key
    stripe_customer_id = account.stripe_customer_id

    return false if !stripe_secret_key
    return false if !stripe_customer_id

    card = Card.new({
        :account => account,
    })

    begin
      Stripe.api_key =  stripe_secret_key

      customer = Stripe::Customer.retrieve(stripe_customer_id)
      stripe_card = customer.sources.create(:source => stripe_token["id"])
    rescue Stripe::StripeError => e
      card.errors[:base] << e.message
      return card
    end

    card.external_id = stripe_card.id
    card.name_on_card = stripe_card.name
    card.brand = stripe_card.brand
    card.last4 = stripe_card.last4
    card.expiration_month = stripe_card.exp_month
    card.expiration_year = stripe_card.exp_year

    return card
  end
end

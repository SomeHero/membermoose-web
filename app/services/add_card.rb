class AddCard
  def self.call(account, stripe_token)
    stripe_secret_key = account.stripe_secret_key
    stripe_customer_id = account.stripe_customer_id

    return false if !stripe_secret_key
    return false if !stripe_customer_id

    card = Card.new({
        :account => account,
        :name_on_card => stripe_token["card"]["name"],
        :brand => stripe_token["card"]["brand"],
        :last4 => stripe_token["card"]["last4"],
        :expiration_month => stripe_token["card"]["exp_month"],
        :expiration_year => stripe_token["card"]["exp_year"]
    })

    begin
      Stripe.api_key =  stripe_secret_key

      customer = Stripe::Customer.retrieve(stripe_customer_id)
      stripe_card = customer.sources.create(:source => stripe_token["id"])

      card.external_id = stripe_card.id
    rescue Stripe::StripeError => e
      card.errors[:base] << e.message
      return card
    end

    return card
  end
end

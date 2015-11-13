class UpdateCard
  def self.call(card, stripe_token, stripe_secret_key)
    stripe_customer_id = card.account.stripe_customer_id
    stripe_card_id = card.external_id

    begin
      customer = Stripe::Customer.retrieve(stripe_customer_id)
      stripe_card = customer.sources.retrieve(stripe_card_id)

      new_card = AddCard.call(
        card.account,
        stripe_token,
        stripe_secret_key
      )

      DeleteCard.call(card, stripe_secret_key)

    rescue Stripe::StripeError => e
      card.errors[:base] << e.message
      return card
    end

    return new_card
  end
end

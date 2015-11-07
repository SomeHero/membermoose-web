class UpdateCard
  def self.call(card, card_options, stripe_secret_key)
    stripe_customer_id = card.account.stripe_customer_id
    stripe_card_id = card.external_id

    begin
      Stripe.api_key =  stripe_secret_key

      customer = Stripe::Customer.retrieve(stripe_customer_id)
      stripe_card = customer.sources.retrieve(stripe_card_id)
      #stripe_card.name = card_options["name_on_card"]
      stripe_card.exp_month = card_options[:expiration_month]
      stripe_card.exp_year = card_options[:expiration_year]
      stripe_card.save
    rescue Stripe::StripeError => e
      card.errors[:base] << e.message
      return card
    end

    card.expiration_month = card_options[:expiration_month]
    card.expiration_year = card_options[:expiration_year]
    card.save

    return card
  end
end

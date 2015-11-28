class DeleteCard
  def self.call(card)
    stripe_secret_key = card.account.stripe_secret_key
    stripe_customer_id = card.account.stripe_customer_id
    stripe_card_id = card.external_id

    return false if !stripe_secret_key
    return false if !stripe_customer_id
    return false if !stripe_card_id

    begin
      Stripe.api_key = stripe_secret_key

      customer = Stripe::Customer.retrieve(stripe_customer_id)
      customer.sources.retrieve(stripe_card_id).delete
    rescue Stripe::StripeError => e
      Rails.logger.debug("Stripe Error when delete card: #{e.message}")

      card.errors[:base] << e.message
      return card
    end

    card.deleted = true
    card.deleted_at = Time.now
    card.save!

    return card
  end
end

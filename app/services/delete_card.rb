class DeleteCard
  def self.call(card, stripe_secret_key)
    begin
      Stripe.api_key =  stripe_secret_key
      stripe_customer_id = card.account.stripe_customer_id
      stripe_card_id = card.external_id

      customer = Stripe::Customer.retrieve(stripe_customer_id)
      customer.sources.retrieve(stripe_card_id).delete
    rescue Stripe::StripeError => e
      card.errors[:base] << e.message
      return card
    end

    card.deleted = true
    card.deleted_at = Time.now
    card.save!
  end
end

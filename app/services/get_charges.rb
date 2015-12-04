class GetCharges
  def self.call(stripe_customer_id, stripe_secret_key)
    begin
      Stripe.api_key = stripe_secret_key

      stripe_charges = Stripe::Charge.all(:customer => stripe_customer_id, :limit => 100)
    rescue Stripe::StripeError => e
      return false, e.message
    end

    return true, stripe_charges.data
  end
end

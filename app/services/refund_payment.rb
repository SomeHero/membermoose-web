class RefundPayment
  def self.call(payment, stripe_secret_key)
    stripe_charge_id = payment.charge.external_id

    Stripe.api_key = stripe_secret_key

    begin
      stripe_charge = Stripe::Charge.retrieve(stripe_charge_id)
      refund = stripe_charge.refund
    rescue Stripe::StripeError => e
      throw e
    end

    payment.status = "Cancelled"
    payment.save

    return payment
  end
end

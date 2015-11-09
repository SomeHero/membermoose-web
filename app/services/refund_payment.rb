class RefundPayment
  def self.call(payment, stripe_secret_key)
    stripe_charge_id = payment.charge.external_id

    begin
      Stripe.api_key = stripe_secret_key

      stripe_charge = Stripe::Charge.retrieve(stripe_charge_id)
      refund = stripe_charge.refund
    rescue Stripe::StripeError => e
      throw e
    end

    payment.status = "Refunded"
    payment.save

    return payment
  end
end

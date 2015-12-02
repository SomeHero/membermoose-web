class RefundPayment
  def self.call(payment)
    stripe_secret_key = payment.stripe_secret_key
    stripe_charge_id = payment.charge.external_id

    if !stripe_secret_key
      payment.errors[:base] << "Stripe Key Not Set"
      return payment
    end if
    if !stripe_charge_id
      payment.errors[:base] << "Charge #{payment.charge.external_id} not found"
      return payment
    end

    begin
      Stripe.api_key = stripe_secret_key

      stripe_charge = Stripe::Charge.retrieve(stripe_charge_id)
      refund = stripe_charge.refund
    rescue Stripe::StripeError => e
      payment.errors[:base] << e.message
      return payment
    end

    payment.status = "Refunded"

    return payment
  end
end

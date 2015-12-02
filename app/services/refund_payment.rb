class RefundPayment
  def self.call(payment)
    stripe_secret_key = payment.stripe_secret_key
    stripe_charge_id = payment.charge.external_id

    return false if !stripe_secret_key
    return false if !stripe_charge_id
    # if !stripe_secret_key
    #   payment.errors[:base] << "Stripe Key Not Set"
    #   return false
    # end if
    # if !stripe_charge_id
    #   payment.errors[:base] << "Charge #{payment.charge.external_id} not found"
    #   return false
    # end

    begin
      Stripe.api_key = stripe_secret_key

      stripe_charge = Stripe::Charge.retrieve(stripe_charge_id)
      refund = stripe_charge.refund
    rescue Stripe::StripeError => e
      #payment.errors[:base] << e.message
      return false
    end

    payment.status = "Refunded"

    return payment
  end
end

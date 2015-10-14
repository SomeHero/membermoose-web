class CreateToken
  def self.call(credit_card_number, expiration_month, expiration_year,
    cvc, stripe_secret_key)

    begin
      Stripe.api_key =  stripe_secret_key

      token = Stripe::Token.create(
        :card => {
          :number => credit_card_number,
          :exp_month => expiration_month,
          :exp_year => expiration_year,
          :cvc => cvc
        }
      )
    rescue Stripe::StripeError => e
      return e.message
    end
    return token
  end
end

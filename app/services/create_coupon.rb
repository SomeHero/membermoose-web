require 'money'

class CreateCoupon
  def self.call(account, options={})
    coupon = Coupon.new(options)

    if !coupon.valid?
      return false, coupon
    end
    if !account.has_connected_stripe
      return false, "You must connect your stripe account before creating a subscription"
    end

    stripe_secret_key = account.stripe_secret_key

    return false, "Stripe key not provided" if !stripe_secret_key

    begin
      Stripe.api_key =  stripe_secret_key

      amount = Money.from_amount(options[:amount].to_f, "USD")

      if coupon.amount?
        amount = Money.from_amount(coupon.discount_amount.to_i, "USD")

        stripe_coupon = Stripe::Coupon.create(
          :amount_off => amount.cents,
          :duration => 'once',
          :currency => 'usd'
        )
      else
        stripe_coupon = Stripe::Coupon.create(
          :percent_off => coupon.discount_amount.to_i,
          :duration => 'once'
        )
      end
    rescue Stripe::StripeError => e
      return false, e.message
    end

    coupon.external_id = stripe_coupon["id"]

    return true, coupon
  end
end

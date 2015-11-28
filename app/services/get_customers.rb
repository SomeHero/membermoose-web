class GetCustomers
  def self.call(options={}, stripe_secret_key)

    begin
      Stripe.api_key =  stripe_secret_key

      customers = Stripe::Customer.all(:limit=>100)
    rescue Stripe::StripeError => e
      return e.message
    end

    return customers.data
  end
end

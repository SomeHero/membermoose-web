class GetCustomers
  def self.call(options={}, stripe_secret_key)

    all_customers = []
    begin
      Stripe.api_key =  stripe_secret_key

      has_more = true
      starting_after_id = 0

      while has_more do
        response = Stripe::Customer.all(:limit=>100, :starting_after => starting_after_id)
        has_more = response["has_more"]
        customers = response.data

        all_customers += customers
        if has_more
          starting_after_id = customers.last["id"]
        end
      end
    rescue Stripe::StripeError => e
      return e.message
    end

    return all_customers
  end
end

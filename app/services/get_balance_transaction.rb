class GetBalanceTransaction
  def self.call(balance_transaction_id, stripe_secret_key)

    begin
      Stripe.api_key =  stripe_secret_key

      balance_transaction = Stripe::BalanceTransaction.retrieve(balance_transaction_id)
    rescue Stripe::StripeError => e
      return false, e.message
    end

    return true, balance_transaction
  end
end

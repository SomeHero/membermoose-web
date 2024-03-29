class GetInvoice
  def self.call(stripe_invoice_id, stripe_secret_key)

    begin
      Stripe.api_key =  stripe_secret_key

      invoice = Stripe::Invoice.retrieve(stripe_invoice_id)
    rescue Stripe::StripeError => e
      return false, "Stripe Error:#{e.message}"
    end

    return true, invoice
  end
end

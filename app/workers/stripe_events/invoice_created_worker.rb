class InvoiceCreatedWorker
  @queue = :invoice_created_worked

  def self.perform(invoice_id)
    invoice = Invoice.find(invoice_id)

    charge = Charge.find_by(:external_invoice_id => invoice.external_id)

    if charge
      subscription = invoice.subscription
      payment = subscription.payments.where(:status => "Pending").first

      payment.status = "Complete"
      payment.save!

      invoice.status = "Paid"
      invoice.save!
    end
  end
end

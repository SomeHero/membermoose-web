class InvoiceCreatedWorker
  @queue = :invoice_created_worked

  def self.perform(invoice_id)
    invoice = Invoice.find(invoice_id)

  end
end

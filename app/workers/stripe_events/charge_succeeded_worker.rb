class ChargeSucceededWorker
  @queue = :charge_succeeded_worker

  def self.perform(charge_id)
    charge = Charge.find(charge_id)

    invoice = Invoice.find_by(:external_id => charge.external_invoice_id)

    if invoice
      subscription = invoice.subscription
      payment = subscription.payments.where(:status => "Pending").first

      if payment
        payment.charge = charge
        payment.status = "Complete"
        payment.save!

        invoice.status = "Paid"
        invoice.save!
      else
        #we should create a new payment object
      end
    end
    #we may want to send the receipt email at this point
  end
end

class ChargeSucceededWorker
  @queue = :charge_succeeded_worker

  def self.perform(payment_id)
    Rails.logger.debug "Stripe Event: Charge Succeeded"

    payment = Payment.find(payment_id)
    payment.status = "Complete"
    payment.save!

    #we may want to send the receipt email at this point
  end
end

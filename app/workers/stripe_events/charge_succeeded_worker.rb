class ChargeSucceededWorker
  @queue = :charge_succeeded_worker

  def self.perform(charge_id)
    charge = Charge.find(charge_id)

    #we may want to send the receipt email at this point
  end
end

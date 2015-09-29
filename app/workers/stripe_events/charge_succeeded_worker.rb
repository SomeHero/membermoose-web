class ChargeSucceededWorker
  @queue = :charge_succeeded_worker

  def self.perform(payment_id)

  end
end

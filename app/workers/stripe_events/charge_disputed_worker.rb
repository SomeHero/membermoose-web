class ChargeDisputedWorker
  @queue = :charge_disputed_worker

  def self.perform(payment_id)

  end
end

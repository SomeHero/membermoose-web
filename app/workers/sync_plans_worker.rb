require 'slack-notifier'

class SyncPlansWorker

  @queue = :sync_plans_worker_queue

  def self.perform(account_id)
    account = Account.find(account_id)
    stripe_payment_processor = PaymentProcessor.where(:name => "Stripe").first
    stripe = account.account_payment_processors.where(:payment_processor => stripe_payment_processor).active.first

    account.plans.each do |plan|
      if plan.needs_sync
        SyncPlan.call(plan)
      end
    end
  end
end

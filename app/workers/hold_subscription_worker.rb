require 'slack-notifier'

class HoldSubscriptionWorker
  @queue = :transaction_email_worker_queue

  def self.perform(subscription_id)
    return false if !Rails.env.production?

  	subscription = Subscription.find(subscription_id)

    raise "Unable to find subscription #{subscription_id}" if !subscription

    self.send_calf_hold_subscription_email subscription
    self.send_bull_hold_subscription_email subscription
  end

  def self.send_calf_hold_subscription_email subscription
    Rails.logger.info "Attempting to send Calf Hold Subscription email"

    UserNotification::UserNotificationRouter.instance.notify_user(UserNotification::Notification::CALF_HOLD_SUBSCRIPTION,
    :from_address => "contact@membermoose.com",
    :from_name => "The Member Moose Team",
    :subject => "Your subscription was put on Hold",
    :user => subscription.account.user,
    :template_name => "Calf Hold Subscription",
    :merge_fields => {
      "merge_plan_name" => subscription.plan_name,
      "merge_calf_name" => subscription.account.full_name,
      "merge_calf_email" => subscription.account.user.email,
    })
  end

  def self.send_bull_hold_subscription_email subscription
    Rails.logger.info "Attempting to send Bull Hold Subscription email"

    UserNotification::UserNotificationRouter.instance.notify_user(UserNotification::Notification::BULL_HOLD_SUBSCRIPTION,
    :from_address => "contact@membermoose.com",
    :from_name => "The Member Moose Team",
    :subject => "A subscription was put on Hold",
    :user => subscription.plan.account.user,
    :template_name => "Bull Hold Subscription",
    :merge_fields => {
      "merge_plan_name" => subscription.plan_name,
      "merge_plan_amount" => ActionController::Base.helpers.number_to_currency(subscription.plan.amount),
      "merge_billing_interval" => subscription.plan.billing_cycle,
      "merge_calf_name" => subscription.account.full_name,
      "merge_calf_email" => subscription.account.user.email,
    })
  end
 end

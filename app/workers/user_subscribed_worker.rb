require 'slack-notifier'

class UserSubscribedWorker
  @queue = :user_subscribed_worker_queue

  def self.perform(subscription_id)

    #return false if !Rails.env.production?
    subscription = Subscription.find(subscription_id)
    return false unless subscription

    self.send_subscribe_email subscription

    notifier = Slack::Notifier.new "membermoose", "EhtDPEm71aIK2F0vzzM0aghS",
                         channel: '#membermoosechatter', username: 'mm-bot'

    if subscription.plan.mm_identifier == "MM_FREE"
      notifier.ping "#{subscription.account.full_name} (#{subscription.account.user.email}) just became a bull!"
    end
    if subscription.plan.mm_identifier == "MM_PRIME"
      notifier.ping "#{subscription.account.full_name} (#{subscription.account.user.email}) just upgraded to MemberMoose Unlimited!"
    end
    #return false unless Rails.env.production?

    #notifier = Slack::Notifier.new "transferllc", "wi8oy1HpbfJLMIR693STWwEk",
                               #channel: '#random', username: 'notifier'

    #notifier.ping "#{user.email_address_or_mobile_number} created a Tran$fer account!"

  end

  def self.send_subscribe_email subscription
    #send user subscribed email to bull
    UserNotification::UserNotificationRouter.instance.notify_user(UserNotification::Notification::SOMEONE_SUBSCRIBED,
    :from_address => "subscriptions@membermoose.com",
    :from_name => "The Member Moose Team",
    :subject => "Somebody Subscribed to Your MemberMoose Plan",
    :user => subscription.plan.account.user,
    :template_name => "Somebody Subscribed",
    :merge_fields => {
      "merge_plan_name" =>  subscription.plan.name,
      "merge_calf_name" => "#{subscription.account.first_name} #{subscription.account.last_name}",
      "merge_calf_email" => subscription.account.user.email,
    })

  end

 end

require 'slack-notifier'

class UserSubscribedWorker
  @queue = :user_subscribed_worker_queue

  def self.perform(user_id)

    #return false if !Rails.env.production?

  	user = User.find(user_id)

  	return false unless user

    self.send_subscribe_email user

    return false unless Rails.env.production?

    #notifier = Slack::Notifier.new "transferllc", "wi8oy1HpbfJLMIR693STWwEk",
                               #channel: '#random', username: 'notifier'

    #notifier.ping "#{user.email_address_or_mobile_number} created a Tran$fer account!"

  end

  def self.send_subscribe_email user
    #send welcome email
    UserNotification::UserNotificationRouter.instance.notify_user(UserNotification::Notification::SOMEONE_SUBSCRIBED,
    :from_address => "subscriptions@membermoose.com",
    :from_name => "The Member Moose Team",
    :subject => "Somebody Subscribed from Your MemberMoose Plan",
    :user => user,
    :template_name => "Somebody Subscribed",
    :merge_fields => {
      "merge_plan_name" =>  "Baby Moose",
      "merge_calf_name" => "James Rhodes",
      "merge_calf_email" => "members@membermoose.com",
    })

  end

 end

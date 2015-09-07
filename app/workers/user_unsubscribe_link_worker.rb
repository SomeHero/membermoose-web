require 'slack-notifier'

class UserUnsubscribeLinkWorker
  @queue = :user_unsubscribe_lin_worker_queue

  def self.perform(user_id)

    return false if !Rails.env.production?

  	user = User.find(user_id)

  	return false unless user

    self.send_unsubscribe_link_email user

    return false unless Rails.env.production?

    #notifier = Slack::Notifier.new "transferllc", "wi8oy1HpbfJLMIR693STWwEk",
                               #channel: '#random', username: 'notifier'

    #notifier.ping "#{user.email_address_or_mobile_number} created a Tran$fer account!"

  end

  def self.send_unsubscribe_link_email user
    #send welcome email
    UserNotification::UserNotificationRouter.instance.notify_user(UserNotification::Notification::UNSUBSCRIBE_LINK,
    :from_address => "subscriptions@membermoose.com",
    :from_name => "The Member Moose Team",
    :subject => "Unsubscribe Link",
    :user => user,
    :template_name => "Unsubscribe Link",
    :merge_fields => {
      "merge_unsubscribe_url" =>  "http://localhost:3000"
    })

  end

 end

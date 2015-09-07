require 'slack-notifier'

class UserSignupWorker
  @queue = :user_signup_worker_queue

  def self.perform(user_id)

    return false if !Rails.env.production?

  	user = User.find(user_id)

  	return false unless user

    self.send_welcome_email user

    return false unless Rails.env.production?

    #notifier = Slack::Notifier.new "transferllc", "wi8oy1HpbfJLMIR693STWwEk",
                               #channel: '#random', username: 'notifier'

    #notifier.ping "#{user.email_address_or_mobile_number} created a Tran$fer account!"

  end

  def self.send_welcome_email user
    #send welcome email
    UserNotification::UserNotificationRouter.instance.notify_user(UserNotification::Notification::USER_WELCOME,
    :from_address => "welcome@membermoose.com",
    :from_name => "The Member Moose Team",
    :subject => "Welcome to Member Moose",
    :user => user,
    :template_name => "Welcome",
    :merge_fields => {
      "merge_logo_url" => "http://localhost:3000",
      "merge_plan_name" =>  "Baby Moose",
      "merge_bull_email" => "members@membermoose.com",
      "merge_manage_account_url" => "http://localhost:3000",
      "merge_create_plan_url" => "http://localhost:3000",
      "merge_plan_amount" => "$100.00",
      "merge_billing_interval" => "Monthly"
    })

  end

 end

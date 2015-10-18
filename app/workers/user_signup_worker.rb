require 'slack-notifier'

class UserSignupWorker

  @queue = :user_signup_worker_queue

  def self.perform(subscription_id)

    #return false if !Rails.env.production?

    subscription = Subscription.find(subscription_id)
    return false unless subscription

    begin
      self.send_welcome_email subscription
    rescue StandardError => e
      Rails.logger.error "Error encountered while attempting to send welcome email: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")

      return false
    end

    #return false unless Rails.env.production?

    #notifier = Slack::Notifier.new "transferllc", "wi8oy1HpbfJLMIR693STWwEk",
                               #channel: '#random', username: 'notifier'

    #notifier.ping "#{user.email_address_or_mobile_number} created a Tran$fer account!"

  end

  def self.send_welcome_email subscription
    #send welcome email
    logo = "mm-logo.png"
    if subscription.plan.account.logo.exists?
      logo = subscription.plan.account.logo.url
    end

    host = "http://www.membermoose-ng.com"
    if !Rails.env.production?
      host = "http://localhost:3000"
    end
    logo_url = host + logo

    UserNotification::UserNotificationRouter.instance.notify_user(UserNotification::Notification::USER_WELCOME,
    :from_address => subscription.plan.account.user.email,
    :from_name => "The #{subscription.plan.account.company_name} Team",
    :subject => "Welcome to #{subscription.plan.account.company_name}",
    :user => subscription.account.user,
    :template_name => "Welcome",
    :merge_fields => {
      "merge_logo_url" => logo_url,
      "merge_plan_name" =>  subscription.plan.name,
      "merge_bull_name" => subscription.plan.account.company_name,
      "merge_bull_email" => subscription.plan.account.user.email,
      "merge_manage_account_url" => "http://localhost:3000",
      "merge_create_plan_url" => "http://localhost:3000",
      "merge_plan_amount" => ActionController::Base.helpers.number_to_currency(subscription.plan.amount),
      "merge_billing_interval" => subscription.plan.billing_cycle
    })

  end

 end

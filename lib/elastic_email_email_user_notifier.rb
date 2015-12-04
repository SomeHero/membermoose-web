# Service that sends user notifications via Elastic Emails emails.
#
# See UserNotification module docs.
#
module UserNotification

  require 'user_notifier.rb'
  require 'elastic_email_api.rb'

  class ElasticEmailEmailUserNotifier

    include UserNotifier

    def send_notification(notification_type, params_hash)

      Rails.logger.debug "ElasticEmailUserNotififer attempting to send '#{notification_type}' notification using params: #{params_hash.inspect}"

      result = ""
      case notification_type
      when UserNotification::Notification::BULL_WELCOME
        user = params_hash[:user]

        template_name = params_hash[:template_name] || "Bull Welcome"
        #subject = ""
        from_address = params_hash[:from_address] || Settings.default_from
        from_name = params_hash[:from_name]|| Settings.default_from_name
        subject = params_hash[:subject] ||  "Welcome to MemberMoose"

        merge_fields = params_hash[:merge_fields]

        result = ElasticEmailApi.send_email(user.email, subject, template_name, from_address, from_name, merge_fields)

      when UserNotification::Notification::CALF_WELCOME
        user = params_hash[:user]

        template_name = params_hash[:template_name] || "Calf Welcome"
        #subject = ""
        from_address = params_hash[:from_address] || Settings.default_from
        from_name = params_hash[:from_name]|| Settings.default_from_name
        subject = params_hash[:subject] ||  "Welcome to MemberMoose"

        merge_fields = params_hash[:merge_fields]

        result = ElasticEmailApi.send_email(user.email, subject, template_name, from_address, from_name, merge_fields)

      when UserNotification::Notification::USER_WELCOME
        user = params_hash[:user]

        template_name = params_hash[:template_name] || "Calf Welcome"
        #subject = ""
        from_address = params_hash[:from_address] || Settings.default_from
        from_name = params_hash[:from_name]|| Settings.default_from_name
        subject = params_hash[:subject] ||  "Welcome to MemberMoose"

        merge_fields = params_hash[:merge_fields]

        result = ElasticEmailApi.send_email(user.email, subject, template_name, from_address, from_name, merge_fields)

      when UserNotification::Notification::SOMEONE_SUBSCRIBED
        user = params_hash[:user]

        template_name = params_hash[:template_name] || "New Subscriber"
        #subject = ""
        from_address = params_hash[:from_address] || Settings.default_from
        from_name = params_hash[:from_name]|| Settings.default_from_name
        subject = params_hash[:subject] ||  "New Subscriber"

        merge_fields = params_hash[:merge_fields]

        result = ElasticEmailApi.send_email(user.email, subject, template_name, from_address, from_name, merge_fields)

      else
        raise "I don't know how to handle notifications of type '#{notification_type}'!"
      end
      Rails.logger.debug 'ElasticEmail result: ' + result

    end

    # For a user that we only have an email address for, get a subscriber ID we can use for them.

  end

end

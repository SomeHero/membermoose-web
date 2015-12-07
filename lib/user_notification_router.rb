# The core router of app notifications to end users. See UserNotification module docs.
#
# To use this thing:
#  * its a singleton, so call .instance to get it
#  * make sure there are UserNotifier implementations plugged in, vi add_notifier (as part of config)
#  * send notifications using send_notification, obeying per-notification-type param rules
#
# A call might look like:
#   UserNotification::UserNotificationRouter.instance.notify_user(UserNotification::Notification::USER_WELCOME, :user => u)
#
module UserNotification

  class UserNotificationRouter

    include Singleton

    attr_accessor :force

    def initialize
      @notifiers = Hash.new
      @force = false
      @notifications = Hash.new
    end

    # Add a UserNotifier to the router.
    #
    # @param channel_type the UserNotification::Channel to hook the notifier to
    # @param notifier the UserNotifier instance to use
    #
    def add_notifier(channel_type, notifier)
      @notifiers[channel_type] = notifier
    end

    # Enable notifications. Notifications that are not enabled will not be sent.
    #
    # @param notifications A Hash of UserNotifier::Notification => boolean
    def enable_notifications(notifications)
      @notifications = notifications
    end

    # Do a user notification.
    #
    # @param notification_type The UserNotification::Notification to send; the logical type
    # @param channel_type The UserNotification::Channel to use, leave empty/nil to use the default for this notification type
    # @param params_hash A Hash of parameters to provide as part of this notification, see Notification docs for what is required
    #
    # @return boolean if notification was sent. Swallow ALL exceptions so we don't break any callers in their critical flows.
    #
    def notify_user(notification_type, channel_type = nil, params_hash)
      begin

        Rails.logger.debug "Beginning notification process for '#{notification_type}', params: #{params_hash.inspect}"

        # First things forst, make sure this notification is even enabled
        if (!@force && (@notifications[notification_type] == nil || @notifications[notification_type] == false))
          Rails.logger.warn "Skipping '#{notification_type}' notification since its not enabled."
          return false
        end

        # Get the details on how to send this -- channel_type as well as common parameters user, gift, and channel_address
        case notification_type
        when UserNotification::Notification::USER_INVITE
          channel_type = channel_type ? channel_type : UserNotification::Channel::EMAIL
          user = nil
          channel_address = (channel_type == UserNotification::Channel::TEXT) ? params_hash[:invitee_phone] : params_hash[:invitee_email]
        when UserNotification::Notification::APP_LINK
          channel_type = channel_type ? channel_type : UserNotification::Channel::TEXT
          user = nil
          channel_address = (channel_type == UserNotification::Channel::TEXT) ? params_hash[:phone] : params_hash[:email]
        when UserNotification::Notification::CALF_WELCOME
          channel_type = channel_type ? channel_type : UserNotification::Channel::EMAIL
          user = params_hash[:user]
        when UserNotification::Notification::BULL_WELCOME
          channel_type = channel_type ? channel_type : UserNotification::Channel::EMAIL
          user = params_hash[:user]
        when UserNotification::Notification::CALF_HOLD_SUBSCRIPTION
          channel_type = channel_type ? channel_type : UserNotification::Channel::EMAIL
          user = params_hash[:user]
        when UserNotification::Notification::BULL_HOLD_SUBSCRIPTION
          channel_type = channel_type ? channel_type : UserNotification::Channel::EMAIL
          user = params_hash[:user]
        when UserNotification::Notification::CALF_UNHOLD_SUBSCRIPTION
          channel_type = channel_type ? channel_type : UserNotification::Channel::EMAIL
          user = params_hash[:user]
        when UserNotification::Notification::BULL_UNHOLD_SUBSCRIPTION
          channel_type = channel_type ? channel_type : UserNotification::Channel::EMAIL
          user = params_hash[:user]
        when UserNotification::Notification::USER_WELCOME
          channel_type = channel_type ? channel_type : UserNotification::Channel::EMAIL
          user = params_hash[:user]
        when UserNotification::Notification::SOMEONE_SUBSCRIBED
          channel_type = channel_type ? channel_type : UserNotification::Channel::EMAIL
          user = params_hash[:user]
        else
          raise "Unknown/invalid notification type: '#{notification_type}'"
        end

        # No channel address figured out already?  Get it now, so we can log it
        if (channel_address.nil?)
          channel_address = UserNotificationRouter.get_user_email_or_phone(user, channel_type)
        end

        # Ok ready to trigger, async or no...
        Rails.logger.debug "Going to try for a '#{notification_type}' notification on the '#{channel_type}' channel to '#{channel_address}'."
        notifier = @notifiers[channel_type]
        #if !Settings.notifications_async
        do_notification(notifier, channel_type, channel_address, notification_type, params_hash, user)
        #else
        #  delay.do_notification(notifier, channel_type, channel_address, notification_type, params_hash, gift, user)
        #end

        return true
      rescue => e
        Rails.logger.error "Error encountered while attempting to deliver notification: #{e.message}"
        Rails.logger.error e.backtrace.join("\n")
        return false
      end
    end

    def self.get_user_email_or_phone(user, channel_type)
      if (channel_type == UserNotification::Channel::EMAIL)
        return self.get_user_email(user)
      else
        return user.mobile_number if user
        return nil
      end
    end

    # Get a good email address for this user, nil if none available
    # TODO do we need to get from external accounts as well?
    def self.get_user_email(user)
      if (user)
        return user.email if user.email
      end
      Rails.logger.warn "We're unable to get an email address for " + (user ? " User #{user.id}" : " a nil user (huh?)")
      return nil
    end

    private

    def do_notification(notifier, channel_type, channel_address, notification_type, params_hash, user)
      #raise "Missing address to send to this user..." if channel_address.nil?
      #Rails.logger.debug "Triggering actual notification via '#{channel_type}' using '#{notifier.class.name}'. Type: #{notification_type} Args: #{params_hash.inspect}"
      Rails.logger.debug "Triggering actual notification via '#{channel_type}' using '#{notifier.class.name}'. Type: #{notification_type}"
      time_start = Time.now
      @notifiers[channel_type].send_notification(notification_type, params_hash)
      #UserNotificationXaction.log(notifier.class.name, channel_type, channel_address, notification_type, Time.now - time_start,  user)
    end

  end

end

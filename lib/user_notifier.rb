# See UserNotification module docs.
#
module UserNotification

  module UserNotifier

    # Send a notification.
    #
    # @param notification_type The type of notification to send (as defined in UserNotification::Notifications)
    # @param params_hash A Hash of all info required for this notification (as defined in UserNotification::Notifications)
    #
    # return nothing, throw on any/all failures to notify
    #
    def send_notification(notification_type, params_hash)
      raise NoMethodError.new "Notification method not implemented, bad UserNotifier!", __method__
    end

  end

end

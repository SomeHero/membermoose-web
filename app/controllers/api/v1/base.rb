module API
  module V1
    class Base < Grape::API

      helpers Devise::Controllers::SignInOut

      rescue_from :all do |e|

        Rails.logger.error "API ERROR #{e.to_s}"

        case e.http_code
        when 400...499, 503, 504

          json = JSON.parse e.response

          Rails.logger.error "#{e.http_code} #{json["minorCode"]} '#{json["message"]}'"

          Rack::Response.new(ActiveSupport::JSON.encode(json), e.http_code, { 'Content-type' => 'application/json' }).finish

        else
          # Log it
          Rails.logger.error "#{e.message}\n\n#{e.backtrace.join("\n")}"

          # Notify external service of the error
          Airbrake.notify(e)

          # Send error and backtrace down to the client in the response body (only for internal/testing purposes of course)
          Rack::Response.new({ message: e.message, backtrace: e.backtrace }, e.http_code, { 'Content-type' => 'application/json' }).finish
        end

      end

      helpers do
        def current_user
          return nil if env['rack.session'][:user_id].nil?
          @current_user ||= User.get(env['rack.session'][:user_id])
        end

        def current_user=(user)
          env['rack.session'][:user_id] = user.id unless user
          @current_user = user
        end
      end

      mount API::V1::Plans
      mount API::V1::Funnel
    end
  end
end

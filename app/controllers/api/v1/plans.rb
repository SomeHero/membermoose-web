module API
  module V1
    class Plans < Grape::API
      version 'v1' # path-based versioning by default
      format :json # We don't like xml anymore

      resource :plans do
        desc "returns all plans for an associated account"
        params do
          #required :account_id, type: Integer, desc: "Account"
        end
        get "" do
          Rails.logger.debug "Getting Plans"

          plans = Plan.all

          plans
        end
      end
    end
  end
end

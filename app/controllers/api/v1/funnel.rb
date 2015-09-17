require 'securerandom'
require 'devise'

module API
  module V1
    class Funnel < Grape::API
      version 'v1' # path-based versioning by default
      format :json # We don't like xml anymore

      resource :funnel do
        desc ""
        params do
          requires :personal_name, type: String, desc: "name of new user"
        end
        post "/step1" do
          Rails.logger.debug "Step 1 of Funnel for #{params["personal_name"]}"

          name_parts = params["personal_name"].split(" ")

          if(name_parts.length > 1)
            first_name = name_parts[0]
            last_name = name_parts[1]
          else
            first_name = params["personal_name"]
          end

          account = Account.create!({
              :user => User.create!({
                :email => "funnel_#{SecureRandom.hex}@membermoose.com",
                :password => SecureRandom.hex
              }),
              :first_name => first_name,
              :last_name => last_name
          })

          session["account_id"] = account.id

          account
        end
        desc ""
        params do
          requires :company_name, type: String, desc: "company name of the account"
        end
        post "/step2" do
          Rails.logger.debug "Step 2 of Funnel for #{params["account_id"]}"

          account_id = session["account_id"]
          error!('500 Internal Server Error', 500) unless account_id

          account = Account.find(account_id)

          error!('404 Not Found', 404) unless account

          account.company_name = params["company_name"]
          account.save!

          account
        end
        desc ""
        params do
          requires :email, type: String, desc: "email for the new account"
          requires :password, type: String, desc: "password for the new account"
        end
        post "/step3" do
          Rails.logger.debug "Step 3 of Funnel for #{params["account_id"]}"

          account_id = session["account_id"]
          error!('500 Internal Server Error', 500) unless account_id

          account = Account.find(account_id)

          error!('404 Not Found', 404) unless account

          user = account.user

          error!('400 Error', 400) unless user

          user.email = params["email"]
          user.password = params["password"]
          user.save!

          sign_in :user, user

          account
        end
      end

    end
  end
end

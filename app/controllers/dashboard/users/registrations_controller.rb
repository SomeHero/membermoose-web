# app/controllers/users/registrations_controller.rb
class Dashboard::Users::RegistrationsController < Devise::RegistrationsController
  helper DeviseHelper

  def new
    super
  end

  def create
    bull = Account.where("LOWER(subdomain) = ?", request.subdomain).first

    if(!bull)
      bull = Account.find_by_id(1)
    end
    build_resource(sign_up_params)

    email_address = params["user"]["email"]
    password = params["user"]["password"]
    first_name = params["first_name"]
    last_name = params["last_name"]
    email = params["company_name"]

    @account, raw_token = CreateUser.call(first_name, last_name, email_address, password, bull)

    begin
      @account.save
    rescue => e
      @account.errors[:base] << e.message
    end

    if @account.save
      sign_in @account.user

      redirect_to dashboard_upload_logo_index_url
    else
      respond_with @account.user
    end
  end

  def update
    super
  end
end

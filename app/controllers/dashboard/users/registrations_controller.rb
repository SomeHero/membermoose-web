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

    resource = build_resource(sign_up_params)
    resource.account = resource.build_account(sign_up_params["account"])
    resource.account.bull = bull

    begin
      resource.save
    rescue => e
      resource.errors[:base] << e.message
    end

    if resource.errors.count == 0
      sign_in resource

      redirect_to dashboard_upload_logo_index_url
    else
      respond_with(resource, location: new_user_registration_path)
    end
  end

  def update
    super
  end

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :account => [:first_name, :last_name, :company_name])
  end

end

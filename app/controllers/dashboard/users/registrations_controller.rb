# app/controllers/users/registrations_controller.rb
class Dashboard::Users::RegistrationsController < Devise::RegistrationsController
  helper DeviseHelper

  def new
    super
  end

  def create
    # add custom create logic here
    @account = Account.new({
      :user => User.new({
        :email => params["user"]["email"],
        :password => params["user"]["password"]
      }),
      :first_name => params["first_name"],
      :last_name => params["last_name"],
      :company_name => params["company_name"],
      :role => Account.roles[:bull]
    })

    if @account.save
      sign_in @account.user

      redirect_to dashboard_upload_logo_index_url
    else
      @user = @account.user
      render new
    end
  end

  def update
    super
  end
end

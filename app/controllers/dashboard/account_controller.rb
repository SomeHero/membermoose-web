class Dashboard::AccountController < DashboardController
  layout 'dashboard'

  def upload_logo
    user = current_user

    user.account.logo = params[:file]
    user.account.has_uploaded_logo = true

    if user.save
      render json: user.to_json
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  def change_subdomain
    user = current_user

    user.account.subdomain = params[:subdomain]
    user.account.has_setup_subdomain = true

    if user.save
      render json: user.to_json
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  def show
      user = current_user

      respond_to do |format|
        format.html
        format.json { render json: user.to_json }
      end
  end

  def update
    user = current_user

    respond_to do |format|
      if user.update(permitted_params)
        format.html  { render action: 'edit' }
        format.json { render :json => user.to_json }
      else
        format.html { render action: 'edit' }
        format.json { render json: user.errors, status: :unprocessable_entity }
      end
    end
  end

  def change_password
    current_password = params["current_password"]
    new_password = params["new_password"]
    new_password_again = params["new_password_again"]

    user = current_user

    if !user.valid_password?(current_password)
      payload = {
        statusText: "Invalid current password",
        statusCode: 1001
      }
      render :json => payload, :status => :bad_request

      return
    end
    user.password = new_password

    if user.save
      sign_in(user, :bypass => true)

      payload = {
        statusCode: 200
      }
      render :json => payload, :status => 200
    else
      render :json => user.errors, :status => :unprocessable_entity
    end
  end

  def upgrade_plan
    #ToDo: we should totally refactor
    #ToDo: need a better way to identify special plan
    free_plan_id = ENV["MEMBERMOOSE_FREE_PLAN_ID"]
    upgraded_plan_id = ENV["MEMBERMOOSE_UPGRADED_PLAN_ID"]

    plan = Plan.find(upgraded_plan_id)
    user = current_user

    account = user.account

    #ToDo: look for free MM subscription and update it to inactive
    email = user.email
    stripe_token = params["stripe_token"]["id"]
    type = params["stripe_token"]["type"]
    stripe_card_id = params["stripe_token"]["card"]["id"]
    card_brand = params["stripe_token"]["card"]["brand"]
    card_last4 = params["stripe_token"]["card"]["last4"]
    exp_month = params["stripe_token"]["card"]["exp_month"]
    exp_year = params["stripe_token"]["card"]["exp_year"]

    account, @subscription, card, raw_token = CreateSubscription.call(
      plan,
      "",
      "",
      email,
      "",
      stripe_token,
      stripe_card_id,
      card_brand,
      card_last4,
      exp_month,
      exp_year,
      ENV["STRIPE_SECRET_KEY"]
    )

    begin
      @subscription.save
    rescue => e
      @subscription.errors[:base] << e.message
    end

    if @subscription.errors.count == 0
      user.account.has_upgraded_plan = true
      user.save

      begin
        Resque.enqueue(UserSignupWorker, @subscription.id)
      rescue
        Rails.logger.error "Error sending User Welcome email #{$!}"
      end

      begin
        Resque.enqueue(UserSubscribedWorker, @subscription.id)
      rescue
        Rails.logger.error "Error sending User Subscribed email #{$!}"
      end
    end

    respond_to do |format|
      if @subscription.errors.count == 0
        format.html  { render action: 'index' }
        format.json { render :json => user.to_json }
      else
        format.html { render action: 'index' }
        format.json { render json: @subscription.errors, status: :bad_request }
      end
    end
  end

  def permitted_params
    params.require(:user).permit(:email, :account_attributes =>[:first_name, :last_name, :company_name, :logo, :subdomain])
  end

  def validate_password

  end
end

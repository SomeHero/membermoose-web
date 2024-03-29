class Dashboard::AccountController < DashboardController
  layout :determine_layout

  def upload_logo
    @user.account.logo = params[:file]
    @user.account.has_uploaded_logo = true

    if @user.account.save
      render json: @user.to_json
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def change_subdomain
    @user.account.subdomain = params[:subdomain]
    @user.account.has_setup_subdomain = true

    if @user.account.save
      render json: @user.to_json
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def show
    respond_to do |format|
      format.html
        ormat.json { render json: @user.to_json }
    end
  end

  def update
    respond_to do |format|
      if @user.update(permitted_params)
        format.html  { render action: 'edit' }
        format.json { render :json => @user.to_json }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def change_password
    current_password = params["current_password"]
    new_password = params["new_password"]
    new_password_again = params["new_password_again"]

    if !@user.valid_password?(current_password)
      payload = {
        statusText: "Invalid current password",
        statusCode: 1001
      }
      render :json => payload, :status => :bad_request

      return
    end
    @user.password = new_password
    @user.password_confirmation = new_password

    if @user.save
      sign_in(@user, :bypass => true)

      payload = {
        statusCode: 200
      }
      render :json => payload, :status => 200
    else
      render :json => @user.errors, :status => :unprocessable_entity
    end
  end

  def upgrade_plan
    #ToDo: we should totally refactor
    #ToDo: need a better way to identify special plan

    free_plan = Plan.find_by_stripe_id("MM_FREE")
    prime_plan = Plan.find_by_stripe_id("MM_PRIME")

    account = @user.account
    free_plan_subscription = account.subscriptions.where(:plan => free_plan).first

    email = @user.email
    stripe_token = params["stripe_token"]

    card = AddCard.call(account, stripe_token)

    if !card.save
      error(402, 402, 'Unable to save card.  Please try again')
      return
    end

    @subscription = ChangeSubscription.call(free_plan_subscription, prime_plan)

    if @subscription
      @user.account.has_upgraded_plan = true
      @user.account.save

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
        format.json { render :json => @user.to_json }
      else
        format.html { render action: 'index' }
        format.json { render json: @subscription.errors, status: :bad_request }
      end
    end
  end

  def permitted_params
    params.require(:user).permit(:email, :account_attributes =>[:first_name, :last_name, :company_name, :logo, :subdomain])
  end
end

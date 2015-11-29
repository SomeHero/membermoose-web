class Bulls::SubscriptionsController < ApplicationController
  layout 'bulls'

  def index
    @subscriptions = current_user.account.subscriptions

    respond_to do |format|
      format.html
      format.json { render :json => { :subscriptions => @subscriptions }}
    end
  end

  def new
    @bull = current_user
    @plans = current_user.account.plans
  end

  def create
    plan = Plan.find(params["subscription"]["plan_id"])
    account = plan.account

    if !plan.can_subscribe?
      error(402, 1001, "Plan can't accept subscriptions at this time, please contact customer support.")
      return
    end

    first_name = params["subscription"]["first_name"]
    last_name = params["subscription"]["last_name"]
    email = params["subscription"]["email"]
    password = params["subscription"]["password"]
    stripe_token = params["subscription"]["stripe_token"]["id"]
    type = params["subscription"]["stripe_token"]["type"]
    stripe_card_id = params["subscription"]["stripe_token"]["card"]["id"]
    card_brand = params["subscription"]["stripe_token"]["card"]["brand"]
    card_last4 = params["subscription"]["stripe_token"]["card"]["last4"]
    exp_month = params["subscription"]["stripe_token"]["card"]["exp_month"]
    exp_year = params["subscription"]["stripe_token"]["card"]["exp_year"]

    account, @subscription, card, raw_token = CreateSubscription.call(
      plan,
      first_name,
      last_name,
      email,
      password,
      stripe_token,
      stripe_card_id,
      card_brand,
      card_last4,
      exp_month,
      exp_year
    )

    begin
      @subscription.save
    rescue => e
      @subscription.errors[:base] << e.message
    end

    if @subscription.errors.count == 0
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

    sign_in account.user

    respond_to do |format|
      if @subscription.errors.count == 0
        format.html  { render action: 'new' }
        format.json { render :json => @subscription.to_json }
      else
        format.html { render action: 'new' }
        format.json { render json: @subscription.errors, status: :bad_request }
      end
    end
  end

  def change
    @subscription = Subscription.find(params[:id])
    @plan = Plan.find(params[:plan_id])

    account = current_user.account

    @subscription = ChangeSubscription.call(@subscription, @plan)

    respond_to do |format|
      format.html  { render action: 'show' }
      format.json { render :json => {:subscription => @subscription}, status: 200 }
    end
  end

  def destroy
    @subscription = Subscription.find(params[:id])

    account = current_user.account

    stripe_payment_processor = PaymentProcessor.where(:name => "Stripe").first
    stripe = @subscription.plan.account.account_payment_processors.where(:payment_processor => stripe_payment_processor).active.first

    @subscription = CancelSubscription.call(@subscription)

    respond_to do |format|
      format.html  { render action: 'show' }
      format.json { render :json => {}, status: 200 }
    end
  end
end

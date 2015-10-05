class Bulls::SubscriptionsController < ApplicationController
  layout 'bulls'

  def new
    @bull = current_user
    @plans = current_user.account.plans
  end

  def create
    plan = Plan.find(params["subscription"]["plan_id"])
    first_name = params["subscription"]["first_name"]
    last_name = params["subscription"]["last_name"]
    email = params["subscription"]["email"]
    stripe_token = params["subscription"]["stripe_token"]["id"]
    type = params["subscription"]["stripe_token"]["type"]
    stripe_card_id = params["subscription"]["stripe_token"]["card"]["id"]
    card_brand = params["subscription"]["stripe_token"]["card"]["brand"]
    card_last4 = params["subscription"]["stripe_token"]["card"]["last4"]
    exp_month = params["subscription"]["stripe_token"]["card"]["exp_month"]
    exp_year = params["subscription"]["stripe_token"]["card"]["exp_year"]

    subscription = CreateSubscription.call(
      plan,
      first_name,
      last_name,
      email,
      stripe_token,
      stripe_card_id,
      card_brand,
      card_last4,
      exp_month,
      exp_year
    )

    begin
      Resque.enqueue(UserSignupWorker, subscription.id)
    rescue
      Rails.logger.error "Error sender User Welcome email #{$!}"
    end

    begin
      Resque.enqueue(UserSubscribedWorker, subscription.id)
    rescue
      Rails.logger.error "Error sending User Subscribed email #{$!}"
    end

    render :json => subscription.to_json
  end
end

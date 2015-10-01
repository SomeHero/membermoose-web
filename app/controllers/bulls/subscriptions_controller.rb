class Bulls::SubscriptionsController < ApplicationController
  layout 'bulls'

  def new
    @bull = current_user
    @plans = current_user.account.plans
  end

  def create
    plan = Plan.find(params["subscription"]["plan_id"])
    email = params["subscription"]["email"]
    token = params["subscription"]["stripe_token"]

    subscription = CreateSubscription.call(
      plan,
      email,
      token
    )

    begin
      Resque.enqueue(UserSignupWorker, subscription.account.user.id)
    rescue
      puts "Error #{$!}"
    end

    begin
      Resque.enqueue(UserSubscribedWorker, subscription.account.user.id)
    rescue
      puts "Error #{$!}"
    end

    render :json => subscription.to_json
  end
end

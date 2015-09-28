class Bulls::SubscriptionsController < ApplicationController
  layout 'bulls'

  def new
    @bull = current_user
    @plans = current_user.account.plans
  end
end

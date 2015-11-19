class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery
  respond_to :html, :json

  def after_sign_in_path_for(resource)
    # return the path based on resource
    if resource.account.is_bull?
      dashboard_plans_path
    else
      dashboard_my_subscriptions_path
    end
  end
end

class DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :get_user
  before_action :get_config

  def index
    if current_user.account.is_bull?
      render :layout => 'dashboard'
    else
      render :layout => 'calf-dashboard'
    end
  end

  def get_user
    @user = current_user
  end

  def get_config
    @config = {
      :publishableKey => ENV["STRIPE_PUBLISHABLE_KEY"]
    }
  end
end

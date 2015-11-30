class DashboardController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_user
  before_filter :get_config

  layout :determine_layout

  def index

  end

  def get_user
    @user = current_user
  end

  def get_config
    @config = {
      :publishableKey => ENV["STRIPE_PUBLISHABLE_KEY"]
    }
  end

  def determine_layout
    if current_user.account.is_bull?
      'dashboard'
    else
      'calf-dashboard'
    end
  end
end

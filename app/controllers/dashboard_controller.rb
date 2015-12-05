class DashboardController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_user
  before_filter :get_config
  before_filter :get_user_and_account

  layout :determine_layout

  def index

  end

  def get_user
    @user = current_user
  end

  def get_user_and_account
    @user = current_user

    if session[:account_id]
      @user.account = @user.accounts.find_by_id(session[:account_id])
    end
    if !@user.account
      @user.account = @user.accounts.first
    end
  end

  def get_config
    @config = {
      :publishableKey => ENV["STRIPE_PUBLISHABLE_KEY"]
    }
  end

  def determine_layout
    if @user.account.is_bull?
      'dashboard'
    else
      'calf-dashboard'
    end
  end
end

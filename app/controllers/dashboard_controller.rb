class DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :get_user

  def index
  end

  def get_user
    @user = current_user
  end
end

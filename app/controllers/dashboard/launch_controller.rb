class Dashboard::LaunchController < ApplicationController
  layout 'dashboard'

  def index
    @user = current_user
  end
end

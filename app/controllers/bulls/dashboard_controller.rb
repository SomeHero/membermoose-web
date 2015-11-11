class Bulls::DashboardController < ApplicationController
  before_action :authenticate_user!

  layout 'bulls-dashboard'

  def index
    bull = Account.where("LOWER(subdomain) = ?", request.subdomain).first
    user = current_user

    @bull = bull.user
    @user = user
  end
end

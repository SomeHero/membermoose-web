class Bulls::DashboardController < ApplicationController
  before_action :authenticate_user!

  layout 'bulls-dashboard'

  def index
    account = Account.where("LOWER(subdomain) = ?", request.subdomain).first

    #ToDo:if account is null we should return a 404
    session[:account_id] = account.id

    @bull = account.user

  end
end

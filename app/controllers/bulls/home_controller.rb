class Bulls::HomeController < ApplicationController
  layout 'bulls'

  def index
    account = Account.where("LOWER(subdomain) = ?", request.subdomain).first

    #ToDo:if account is null we should return a 404
    session[:account_id] = account.id

    @bull = account.user

    respond_to do |format|
      format.html
    end
  end

end

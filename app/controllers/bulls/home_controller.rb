class Bulls::HomeController < ApplicationController
  layout 'bulls'

  def index
    account = Account.where("LOWER(subdomain) = ?", request.subdomain).first

    if !account
      render :file => 'public/404.html', :status => :not_found, :layout => false

      return
    end

    session[:account_id] = account.id

    @bull = account.user
    @bull.account = account

    respond_to do |format|
      format.html
    end
  end

end

class Bulls::HomeController < ApplicationController
  layout 'bulls'

  def index
    account = Account.where(:subdomain => request.subdomain).first

    session[:account_id] = account.id

    @bull = account.user

    respond_to do |format|
      format.html
    end
  end

end

class Bulls::PlansController < ApplicationController
  layout 'bulls'

  def index
    account_id = session[:account_id]
    account = Account.find(account_id)

    @plans = account.plans.public_plans

    respond_to do |format|
      format.html
      format.json { render :json => { :plans => @plans }}
    end
  end

  def show
    account_id = session[:account_id]
    account = Account.find(account_id)

    @plan = account.plans.find_by_guid(params[:id])

    respond_to do |format|
      format.html
      format.json { render :json => { :plan => @plan }}
    end
  end

end

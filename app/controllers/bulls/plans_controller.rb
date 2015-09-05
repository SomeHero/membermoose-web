class Bulls::PlansController < DashboardController
  layout 'bulls'

  def index
    account = Account.where(:subdomain => request.subdomain).first

    @bull = account.user
    @plans = account.plans

    respond_to do |format|
      format.html
      format.json { render :json => @plans.to_json }
    end
  end

end

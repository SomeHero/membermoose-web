class Bulls::PlansController < DashboardController
  layout 'bulls'

  def index
    @bull = current_user
    @plans = current_user.account.plans

    respond_to do |format|
      format.html
      format.json { render :json => @plans.to_json }
    end
  end

end

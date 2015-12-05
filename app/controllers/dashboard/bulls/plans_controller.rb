class Dashboard::Bulls::PlansController < DashboardController
  layout :determine_layout

  def index
    @plans = @user.account.bull.plans.active.paginate(:page => params[:page], :per_page => 100)

    respond_to do |format|
      format.html
      format.json { render :json => @plans.to_json }
    end
  end

  def show
    @plan = @user.account.bull.plans.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render :json => @plan.to_json }
    end
  end

end

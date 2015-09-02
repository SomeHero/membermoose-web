class Dashboard::PlansController < DashboardController
  layout 'dashboard'

  def index
    @plans = current_user.account.plans

    respond_to do |format|
      format.html
      format.json { render :json => @plans.to_json }
    end
  end

  def new

  end

  def create

  end

  def edit

  end

  def update

  end

end

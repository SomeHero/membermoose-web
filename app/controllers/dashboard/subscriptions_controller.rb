class Dashboard::SubscriptionsController < DashboardController
  layout 'dashboard'

  def index
    @subscriptions = current_user.account.subscriptions

    respond_to do |format|
      format.html
      format.json { render :json => @subscriptions.to_json }
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

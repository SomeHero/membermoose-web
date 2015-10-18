class Dashboard::SubscriptionsController < DashboardController
  layout 'dashboard'

  def index
    query = current_user.account.subscriptions_plans
      .joins(:account)

    if params[:plan_id].present?
      query = query.where("plans.id" => params["plan_id"])
    end
    if params[:first_name].present?
      query = query.where("accounts.first_name" => params["first_name"])
    end
    if params[:last_name].present?
      query = query.where("accounts.last_name" => params["last_name"])
    end
    @total_items = query.count
    @subscriptions = query
      .paginate(:page => params[:page], :per_page => 10)
      .order("last_name asc")

    respond_to do |format|
      format.html
      format.json { render :json => { :subscriptions => @subscriptions,
        :total_items => @total_items }}
    end
  end

  def count
    query = current_user.account.subscriptions_plans
      .joins(:account)

    if params[:plan_id].present?
      query = query.where("plans.id" => params["plan_id"])
    end
    if params[:first_name].present?
      query = query.where("accounts.first_name" => params["first_name"])
    end
    if params[:last_name].present?
      query = query.where("accounts.last_name" => params["last_name"])
    end

    render :json => { :count => query.count }
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

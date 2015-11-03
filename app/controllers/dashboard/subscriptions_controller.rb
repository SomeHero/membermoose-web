class Dashboard::SubscriptionsController < DashboardController
  layout 'dashboard'

  def index
    query = current_user.account.subscriptions_plans
      .joins(:account)

    if params[:plan_id].present?
      query = query.where("plans.id" => params["plan_id"])
    end
    if params[:first_name].present?
      query = query.where("LOWER(accounts.first_name) like ?", "%#{params["first_name"].downcase}%")
    end
    if params[:last_name].present?
      query = query.where("LOWER(accounts.last_name) like ?",  "%#{params["last_name"].downcase}%")
    end
    if params[:status].present?
      query = query.where("status" => params["status"])
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
      query = query.where("LOWER(accounts.first_name) like ?", "%#{params["first_name"].downcase}%")
    end
    if params[:last_name].present?
      query = query.where("LOWER(accounts.last_name) like ?",  "%#{params["last_name"].downcase}%")
    end
    if params[:status].present?
      query = query.where("status" => params["status"])
    end

    render :json => { :count => query.count }
  end

  def change
    @subscription = Subscription.find(params[:id])
    @plan = Plan.find(params[:plan_id])

    @subscription = ChangeSubscription.call(@subscription, @plan)

    respond_to do |format|
      format.html  { render action: 'show' }
      format.json { render :json => {:subscription => @subscription}, status: 200 }
    end
  end

  def destroy
    account = current_user.account

    stripe_payment_processor = PaymentProcessor.where(:name => "Stripe").first
    stripe = account.account_payment_processors.where(:payment_processor => stripe_payment_processor).active.first


    @subscription = Subscription.find(params[:id])
    @subscription = CancelSubscription.call(@subscription, stripe.secret_token)

    respond_to do |format|
      format.html  { render action: 'show' }
      format.json { render :json => {}, status: 200 }
    end
  end

end

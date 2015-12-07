class Dashboard::SubscriptionsController < DashboardController
  layout :determine_layout

  def index
    query = @user.account.subscriptions_plans
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
    query = @user.account.subscriptions_plans
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
    account = @user.account

    @subscription = account.subscriptions_plans.find(params[:id])
    @plan = account.plans.find(params[:plan_id])

    @subscription = ChangeSubscription.call(@subscription, @plan)

    respond_to do |format|
      format.html  { render action: 'show' }
      format.json { render :json => {:subscription => @subscription}, status: 200 }
    end
  end

  def destroy
    account = @user.account

    @subscription = account.subscriptions_plans.find(params[:id])
    @subscription = CancelSubscription.call(@subscription)

    respond_to do |format|
      if @subscription
        format.html  { render action: 'show' }
        format.json { render :json => {}, status: 200 }
      else
        format.html { render action: 'show' }
        format.json { render json: {}, status: :bad_request }
      end
    end
  end

  def hold
    account = current_user.account

    Rails.logger.info "Holding Subscription #{params["id"]} for #{account.full_name}"

    subscription = Subscription.find(params["id"])

    results = HoldSubscription.call(subscription)
    if !results[0]
      error(402, 402, "Unable to hold subscription. #{results[1]}.")

      return
    end

    subscription = results[1]

    subscription.status = Subscription.statuses[:hold]

    if subscription.save
      begin
        Resque.enqueue(HoldSubscriptionWorker, subscription.id)
      rescue => e
        Rails.logger.error "Unable to queue unhold subscription job. #{e.message}"
      end

      render :json => {:subscription => subscription}
    else
      error(402, 402, 'Unable to unhold subscription. Please try again.')
    end
  end

  def unhold
    account = current_user.account

    subscription = Subscription.find(params["id"])

    Rails.logger.info "Un-holding Subscription #{subscription.plan.name} for #{subscription.account.full_name}"

    results = UnholdSubscription.call(subscription)
    if !results[0]
      error(402, 402, "Unable to unhold subscription. #{results[1]}.")

      return
    end

    subscription = results[1]

    subscription.status = Subscription.statuses[:subscribed]

    if subscription.save
      begin
        Resque.enqueue(UnholdSubscriptionWorker, subscription.id)
      rescue => e
        Rails.logger.error "Unable to queue unhold subscription job. #{e.message}"
      end

      render :json => {:subscription => subscription}
    else
      error(402, 402, 'Unable to unhold subscription. Please try again.')
    end
  end
end

class Dashboard::PlansController < DashboardController
  layout :determine_layout

  def index
    @plans = @user.account.plans.active.paginate(:page => params[:page], :per_page => 100)

    respond_to do |format|
      format.html
      format.json { render :json => @plans.to_json }
    end
  end

  def show
    @plan = @user.account.plans.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render :json => @plan.to_json }
    end
  end

  def new

  end

  def create
    account = @user.account
    stripe_payment_processor = PaymentProcessor.where(:name => "Stripe").first
    stripe = account.account_payment_processors.where(:payment_processor => stripe_payment_processor).active.first

    plan_options = {
        :account => account,
        :name => params["plan"]["name"],
        :stripe_id => params["plan"]["name"],
        :description => params["plan"]["description"],
        :feature_1 => params["plan"]["feature1"],
        :feature_2 => params["plan"]["feature2"],
        :feature_3 => params["plan"]["feature3"],
        :feature_4 => params["plan"]["feature4"],
        :amount => params["plan"]["amount"],
        :billing_cycle => params["plan"]["billing_cycle"],
        :billing_interval => params["plan"]["billing_interval"],
        :trial_period_days => params["plan"]["free_trial_period"],
        :terms_and_conditions => params["plan"]["terms_and_conditions"],
        :public => true
    }
    if params["plan"]["discount_trial"]
      coupon_options = {
        :coupon_type => params["coupon"]["coupon_type"],
        :discount_amount => params["coupon"]["discount_amount"]
      }
    end
    results = CreatePlan.call(account, plan_options, coupon_options)

    if !results[0]
      error(402, 402, "Unable to create plan.  #{results[1]}")

      return
    end

    @plan = results[1]

    if @plan.save
      account.has_created_plan = true
      account.save

      if results[2]
        coupon = results[2]

        if coupon.save
          sub_discount_coupon = SubscriptionDiscountCoupon.create({
            :plan => @plan,
            :coupon => coupon
          })
        else
          error(402, 402, 'Unable to create subscription discount coupon.  Please try again.')

          return
        end
      end
    else
      error(402, 402, 'Unable to create plan.  Please try again.')

      return
    end

    respond_to do |format|
      if @plan.errors.count == 0 && @plan.save
        format.html  { render action: 'new' }
        format.json { render :json => @plan.to_json }
      else
        format.html { render action: 'new' }
        format.json { render json: @plan.errors, status: :bad_request }
      end
    end
  end

  def edit

  end

  def update
    plan = @user.account.plans.find(permitted_params[:id])

    respond_to do |format|
      if plan.update(permitted_params)
        format.html  { render action: 'edit' }
        format.json { render :json => plan.to_json }
      else
        format.html { render action: 'edit' }
        format.json { render json: plan.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    Rails.logger.info("Attempting to Delete Plan")

    account = @user.account
    stripe_payment_processor = PaymentProcessor.where(:name => "Stripe").first
    stripe = account.account_payment_processors.where(:payment_processor => stripe_payment_processor).active.first

    @plan = Plan.find(params["id"])

    #ToDo: might need to refactor
    #only delete from stripe if the plan is synced
    if !@plan.needs_sync && stripe
      @plan = DeletePlan.call(@plan)
    end

    @plan.deleted = true
    @plan.deleted_at = Time.now

    @plan.subscriptions.update_all(:status => Subscription.statuses[:cancelled])

    respond_to do |format|
      if @plan && @plan.errors.count == 0 && @plan.save
        format.html  { render action: 'index' }
        format.json { render json: {}, status: 200 }
      else
        format.html { render action: 'index' }
        format.json { render json: @plan.errors, status: :bad_request }
      end
    end
  end

  def get_stripe_plans
    account = @user.account
    stripe_payment_processor = PaymentProcessor.where(:name => "Stripe").first
    stripe = account.account_payment_processors.where(:payment_processor => stripe_payment_processor).active.first

    #ToDo: check for stripe processor
    results = GetPlans.call({}, stripe.secret_token)

    respond_to do |format|
      if results[0]
        plans = results[1]
        format.json { render :json => { :plans => plans } }
      else
        format.json { render :json => {}, status: :bad_request }
      end
    end
  end

  def import_stripe_plans
    account = @user.account

    stripe_plans = params["plans"]

    plans = []
    stripe_plans.each do |stripe_id|
      results = ImportPlan.call(account, stripe_id)

      if !results[0]
        Rails.logger.error "Unable to import plan #{stripe_id}: #{results[0]}"

        next
      end

      plan = results[1]
      if plan.save
        plans.push(plan)
      end
    end

    begin
      Resque.enqueue(GetCustomersWorker, account.id)
    rescue
      Rails.logger.error "Error Queuing GetCustomerWorker for #{account.id} #{$!}"
    end

    respond_to do |format|
      format.json { render :json => { :plans => plans } }
    end
  end

  def permitted_params
    params.require(:plan).permit(:id, :name, :description, :feature_1, :feature_2, :feature_3, :feature_4, :amount, :billing_cycle, :billing_interval, :trial_period_days, :terms_and_conditions, :public)
  end

end

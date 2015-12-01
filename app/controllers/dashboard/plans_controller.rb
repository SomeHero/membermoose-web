class Dashboard::PlansController < DashboardController
  layout :determine_layout

  def index
    @plans = current_user.account.plans.paginate(:page => params[:page], :per_page => 100)

    respond_to do |format|
      format.html
      format.json { render :json => @plans.to_json }
    end
  end

  def show
    @plan = current_user.account.plans.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render :json => @plan.to_json }
    end
  end

  def new

  end

  def create
    account = current_user.account
    stripe_payment_processor = PaymentProcessor.where(:name => "Stripe").first
    stripe = account.account_payment_processors.where(:payment_processor => stripe_payment_processor).active.first

    @plan = CreatePlan.call(account, {
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
    })

    if @plan.errors.count == 0
      account.has_created_plan = true
      account.save
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
    plan = current_user.account.plans.find(permitted_params[:id])

    respond_to do |format|
      if plan.update(permitted_params)
        format.html  { render action: 'edit' }
        format.json { render :json => plan.to_json }
      else
        format.html { render action: 'edit' }
        format.json { render json: current_user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    Rails.logger.info("Attempting to Delete Plan")

    account = current_user.account
    stripe_payment_processor = PaymentProcessor.where(:name => "Stripe").first
    stripe = account.account_payment_processors.where(:payment_processor => stripe_payment_processor).active.first

    @plan = Plan.find(params["id"])

    #ToDo: might need to refactor
    #only delete from stripe if the plan is synced
    if !@plan.needs_sync && stripe
      @plan = DeletePlan.call(@plan)
    end

    respond_to do |format|
      if @plan && @plan.errors.count == 0 && @plan.delete
        format.html  { render action: 'index' }
        format.json { render json: {}, status: 200 }
      else
        format.html { render action: 'index' }
        format.json { render json: @plan.errors, status: :bad_request }
      end
    end
  end

  def get_stripe_plans
    account = current_user.account
    stripe_payment_processor = PaymentProcessor.where(:name => "Stripe").first
    stripe = account.account_payment_processors.where(:payment_processor => stripe_payment_processor).active.first

    plans = GetPlans.call({}, stripe.secret_token)

    respond_to do |format|
      format.json { render :json => { :plans => plans } }
    end
  end

  def import_stripe_plans
    account = current_user.account

    stripe_plans = params["plans"]

    plans = []
    stripe_plans.each do |stripe_id|
      plan = ImportPlan.call(account, stripe_id)
      if plan.save
        plans.push(plan)
      end
    end


    begin
      Resque.enqueue(GetCustomersWorker, account.id)
    rescue
      puts "Error #{$!}"
    end

    respond_to do |format|
      format.json { render :json => { :plans => plans } }
    end
  end

  def permitted_params
    params.require(:plan).permit(:id, :name, :description, :feature_1, :feature_2, :feature_3, :feature_4, :amount, :billing_cycle, :billing_interval, :trial_period_days, :terms_and_conditions, :public)
  end

end

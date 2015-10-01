class Dashboard::PlansController < DashboardController
  layout 'dashboard'

  def index
    @plans = current_user.account.plans.paginate(:page => params[:page], :per_page => 10)

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
    @plan = Plan.new(permitted_params)
    @plan.account = current_user.account

    respond_to do |format|
      if @plan.save
        format.html  { render action: 'new' }
        format.json { render :json => @plan.to_json }
      else
        format.html { render action: 'new' }
        format.json { render json: current_user.errors, status: :unprocessable_entity }
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

  def permitted_params
    params.require(:plan).permit(:id, :name, :description, :amount, :billing_cycle, :billing_interval, :trial_period_days, :terms_and_conditions, :public)
  end

end

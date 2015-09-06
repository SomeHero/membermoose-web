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
    plan = current_user.account.plans.find(permitted_params[:id])

    respond_to do |format|
      if plan.update(permitted_params)
        format.html  { render action: 'edit' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: current_user.errors, status: :unprocessable_entity }
      end
    end
  end

  def permitted_params
    params.require(:plan).permit(:id, :name, :description, :amount, :billing_cycle, :billing_interval, :free_trial_period, :terms_and_conditions, :public)
  end

end

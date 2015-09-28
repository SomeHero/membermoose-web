class Dashboard::PaymentsController < DashboardController
  layout 'dashboard'

  def index
    @payments = current_user.account.payments.paginate(:page => params[:page], :per_page => 10)

    respond_to do |format|
      format.html
      format.json { render :json => @payments.to_json }
    end
  end

  def edit

  end

  def update

  end

end

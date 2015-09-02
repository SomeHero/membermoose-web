class Dashboard::PaymentsController < DashboardController
  layout 'dashboard'

  def index
    @payments = current_user.account.payments

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

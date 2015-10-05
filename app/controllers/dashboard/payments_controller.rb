class Dashboard::PaymentsController < DashboardController
  layout 'dashboard'

  def index
    @total_items = current_user.account.payments.count
    @payments = current_user.account.payments
      .paginate(:page => params[:page], :per_page => 10)

    respond_to do |format|
      format.html
      format.json { render :json => { :payments => @payments,
        :total_items => @total_items }}
    end
  end

  def edit

  end

  def update

  end

end

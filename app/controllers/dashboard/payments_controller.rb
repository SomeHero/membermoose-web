class Dashboard::PaymentsController < DashboardController
  layout 'dashboard'

  def index
    query = current_user.account.payments
      .joins(:account_payment_processor => :account )

    if params[:first_name].present?
      query = query.where("accounts.first_name" => params["first_name"])
    end
    if params[:last_name].present?
      query = query.where("accounts.last_name" => params["last_name"])
    end

    @total_items = query.count
    @payments = query
      .paginate(:page => params[:page], :per_page => 10)
      .order("created_at desc")

    respond_to do |format|
      format.html
      format.json { render :json => { :payments => @payments,
        :total_items => @total_items }}
    end
  end

  def count
    query = current_user.account.payments
      .joins(:account_payment_processor => :account )

    if params[:first_name].present?
      query = query.where("accounts.first_name" => params["first_name"])
    end
    if params[:last_name].present?
      query = query.where("accounts.last_name" => params["last_name"])
    end

    render :json => { :count => query.count }
  end

  def edit

  end

  def update

  end

end

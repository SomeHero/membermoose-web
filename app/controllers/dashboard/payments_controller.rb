class Dashboard::PaymentsController < DashboardController
  layout 'dashboard'

  def index
    query = current_user.account.payments
      .joins(:account_payment_processor => :account )

    if params[:from_date]
      query = query.where("payments.created_at >= ?", params["from_date"])
    end
    if params[:to_date]
      query = query.where("payments.created_at <= ?", params["to_date"])
    end
    if params[:first_name].present?
      query = query.where("LOWER(accounts.first_name) like ?", "%#{params["first_name"].downcase}%")
    end
    if params[:last_name].present?
      query = query.where("LOWER(accounts.last_name) like ?", "%#{params["last_name"].downcase}%")
    end
    if params[:from_amount].present? & params[:to_amount].present?
      query = query.where("amount >= ?", params["from_amount"])
    end
    if params[:to_amount].present?
      query = query.where("amount <= ?", params["to_amount"])
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

    if params[:from_date]
      query = query.where("created_at >= ?", params["from_date"])
    end
    if params[:to_date]
      query = query.where("created_at <= ?", params["to_date"])
    end
    if params[:first_name].present?
      query = query.where("LOWER(accounts.first_name) like ?", "%#{params["first_name"].downcase}%")
    end
    if params[:last_name].present?
      query = query.where("LOWER(accounts.last_name) like ?", "%#{params["last_name"].downcase}%")
    end
    if params[:from_amount].present? & params[:to_amount].present?
      query = query.where("amount >= ?", params["from_amount"])
    end
    if params[:to_amount].present?
      query = query.where("amount <= ?", params["to_amount"])
    end

    render :json => { :count => query.count }
  end

  def refund
    @payment = Payment.find(params[:id])
    stripe_payment_processor = PaymentProcessor.where(:name => "Stripe").first
    stripe = @payment.account.account_payment_processors.where(:payment_processor => stripe_payment_processor).first

    @payment = RefundPayment.call(@payment, stripe.secret_token)

    respond_to do |format|
      format.html  { render action: 'show' }
      format.json { render :json => {:subscription => @subscription}, status: 200 }
    end
  end

end

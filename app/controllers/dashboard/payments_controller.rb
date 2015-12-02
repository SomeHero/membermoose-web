class Dashboard::PaymentsController < DashboardController
  layout :determine_layout

  def index
    query = current_user.account.payments

    if params[:from_date]
      query = query.where("payments.transaction_date >= ?", params["from_date"])
    end
    if params[:to_date]
      query = query.where("payments.transaction_date <= ?", params["to_date"])
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
      .order("transaction_date desc")

    respond_to do |format|
      format.html
      format.json { render :json => { :payments => @payments,
        :total_items => @total_items }}
    end
  end

  def count
    query = current_user.account.payments

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
    account = current_user.account

    payment = account.payments.find(params[:id])
    @payment = RefundPayment.call(payment)

    if @payment.errors.count == 0 && @payment.save
      render :json => {:payment => @payment.to_json}, status: 200
    else
      format.json { render json: @payment.errors, status: :bad_request }
    end
  end

end

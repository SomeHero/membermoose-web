class Dashboard::MembersController < DashboardController
  layout 'dashboard'

  def index
    query = current_user.account.members
    .joins(:user)

    if params[:first_name].present?
      query = query.where("accounts.first_name" => params["first_name"])
    end
    if params[:last_name].present?
      query = query.where("accounts.last_name" => params["last_name"])
    end
    if params[:email_address].present?
      query = query.where("users.email" => params["email_address"])
    end
    if params[:plan_id].present?
      query = query.where("plans.id" => params["plan_id"])
    end
    if params[:status].present?
      query = query.where("status" => params["status"])
    end

    @total_items = query.count
    @members = query
      .paginate(:page => params[:page], :per_page => 10)
      .order("last_name asc")

    respond_to do |format|
      format.html
      format.json { render :json => { :members => @members,
        :total_items => @total_items }}
    end
  end

  def count
    query = current_user.account.members
    .joins(:user)

    if params[:first_name].present?
      query = query.where("accounts.first_name" => params["first_name"])
    end
    if params[:last_name].present?
      query = query.where("accounts.last_name" => params["last_name"])
    end
    if params[:email_address].present?
      query = query.where("users.email" => params["email_address"])
    end

    render :json => { :count => query.count }
  end

  def edit

  end

  def update
    account = current_user.account.members.find(permitted_params[:id])

    # @user = current_user
    # begin
    #   Resque.enqueue(UserSignupWorker, @user.id)
    # rescue
    #   puts "Error #{$!}"
    # end

    respond_to do |format|
      if account.update(permitted_params)
        format.html  { render action: 'edit' }
        format.json { render :json => account.to_json }
      else
        format.html { render action: 'edit' }
        format.json { render json: account.errors, status: :unprocessable_entity }
      end
    end
  end

  def permitted_params
    params.require(:member).permit(:id, :first_name, :last_name, :user_attributes => [:email])
  end

end

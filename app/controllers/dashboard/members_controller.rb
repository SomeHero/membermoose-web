class Dashboard::MembersController < DashboardController
  layout :determine_layout

  def index
    query = @user.account.members
    .joins(:user)

    if params[:first_name].present?
      query = query.where("LOWER(accounts.first_name) like ?", "%#{params["first_name"].downcase}%")
    end
    if params[:last_name].present?
      query = query.where("LOWER(accounts.last_name) like ?", "%#{params["last_name"].downcase}%")
    end
    if params[:email_address].present?
      query = query.where("LOWER(users.email) like ?", "%#{params["email_address"].downcase}%")
    end
    if params[:plan_id].present?
      query = query.where("plans.id" => params["plan_id"])
    end
    if params[:status].present?
      query = query.where("accounts.id in (Select subscriptions.account_id from subscriptions inner join plans on subscriptions.plan_id = plans.id where plans.account_id = #{@user.account.id} and subscriptions.status = #{params[:status]})")
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
    query = @user.account.members
    .joins(:user)

    if params[:first_name].present?
      query = query.where("LOWER(accounts.first_name) like ?", "%#{params["first_name"].downcase}%")
    end
    if params[:last_name].present?
      query = query.where("LOWER(accounts.last_name) like ?", "%#{params["last_name"].downcase}%")
    end
    if params[:email_address].present?
      query = query.where("LOWER(users.email) like ?", "%#{params["email_address"].downcase}%")
    end
    if params[:plan_id].present?
      query = query.where("plans.id" => params["plan_id"])
    end
    if params[:status].present?
      query = query.where("accounts.id in (Select subscriptions.account_id from subscriptions inner join plans on subscriptions.plan_id = plans.id where plans.account_id = #{@user.account.id} and subscriptions.status = #{params[:status]})")
    end

    render :json => { :count => query.count }
  end

  def edit

  end

  def update
    account = @user.account.members.find(permitted_params[:id])

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

class Dashboard::MembersController < DashboardController
  layout 'dashboard'

  def index
    @total_items = current_user.account.members.count
    @members = current_user.account.members
      .paginate(:page => params[:page], :per_page => 10)
      .order("last_name asc")

    respond_to do |format|
      format.html
      format.json { render :json => { :members => @members,
        :total_items => @total_items }}
    end
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

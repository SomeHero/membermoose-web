class Dashboard::MembersController < DashboardController
  layout 'dashboard'

  def index
    @members = current_user.account.members

    respond_to do |format|
      format.html
      format.json { render :json => @members.to_json }
    end
  end

  def edit

  end

  def update

  end

end

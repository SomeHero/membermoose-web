class Dashboard::AccountController < DashboardController
  layout 'dashboard'

  def upload_logo
    user = current_user

    user.account.logo = params[:file]
    user.save

    render json: user.account.to_json
  end

  def show
      user = current_user

      respond_to do |format|
        format.html
        format.json { render json: user.to_json }
      end
  end

  def update
    respond_to do |format|
      if current_user.update(permitted_params)
        format.html  { render action: 'edit' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: current_user.errors, status: :unprocessable_entity }
      end
    end
  end

  def permitted_params
    params.require(:user).permit(:email, :account_attributes =>[:first_name, :last_name, :company_name, :logo, :subdomain])
  end

end

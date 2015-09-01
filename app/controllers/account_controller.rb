class AccountController < DashboardController
  layout 'dashboard'

  def edit

  end

  def update
    respond_to do |format|
      if current_user.update(permitted_params)
        format.html  { render action: 'edit' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: account.errors, status: :unprocessable_entity }
      end
    end

  end

  def permitted_params
    params.require(:user).permit(:email, :account_attributes =>[:first_name, :last_name, :company_name])
  end

end

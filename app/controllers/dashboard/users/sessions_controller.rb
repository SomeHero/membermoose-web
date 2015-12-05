class Dashboard::Users::SessionsController < Devise::SessionsController
# before_filter :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    super
  end

  # POST /resource/sign_in
  def create
    self.resource = warden.authenticate!(auth_options)

    bull = Account.where("LOWER(subdomain) = ?", request.subdomain).first

    #if there is no bull, then the user logged in from MM, set there account to the last account
    #they used or the first
    if !bull
      #find the user's bull account
      resource.accounts.each do |account|
        if account.role == Account.roles[:bull]
          session[:account_id] = account.id
          resource.account = account
        end
      end
    else
      #try to find a user account associated with the bull
      resource.accounts.each do |account|
        if account.bull == bull
          session[:account_id] = account.id
          resource.account = account
        end
      end
    end

    #if we got this faor and still haven't assigned an account, just grab the first
    if !self.resource.account
      session[:account_id] = self.resource.accounts.first.id
      resource.account = self.resource.accounts.first
    end

    if self.resource.account
      set_flash_message(:notice, :signed_in) if is_navigational_format?
      sign_in(resource_name, resource)

      if !session[:return_to].blank?
        redirect_to session[:return_to]
        session[:return_to] = nil
      else
        respond_with resource, :location => after_sign_in_path_for(resource)
      end
    end
  end


  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.for(:sign_in) << :attribute
  # end
end

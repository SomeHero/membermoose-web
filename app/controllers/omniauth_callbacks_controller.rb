class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def stripe_connect
    # Delete the code inside of this method and write your own.
    # The code below is to show you where to access the data.

    payment_processor = PaymentProcessor.where(:name => "Stripe").first

    #parse out oauth_user_id, name, email, token, refresh_token
    oauth_user_id =request.env["omniauth.auth"]["uid"]
    name = request.env["omniauth.auth"]["info"]["name"]
    email = request.env["omniauth.auth"]["info"]["email"]
    token = request.env["omniauth.auth"]["info"]["stripe_publishable_key"]
    refresh_token = request.env["omniauth.auth"]["credentials"]["refresh_token"]
    #raise request.env["omniauth.auth"].to_yaml
    account_payment_processor_oauth = AccountPaymentProcessorOauth.where(
      :account => current_user.account,
      :payment_processor => payment_processor
    ).first

    if !account_payment_processor_oauth
      account_payment_processor_oauth = AccountPaymentProcessorOauth.new({
          account: current_user.account,
          payment_processor: payment_processor,
          oauth_user_id: oauth_user_id,
          name: name,
          email: email,
          token: token,
          refresh_token: refresh_token
      })
    else
      account_payment_processor_oauth.oauth_user_id = oauth_user_id
      account_payment_processor_oauth.name = name
      account_payment_processor_oauth.email = email
      account_payment_processor_oauth.token = token
      account_payment_processor_oauth.refresh_token = refresh_token
    end

    @payment_processor = payment_processor
    @account_payment_processor_oauth = account_payment_processor_oauth

    if account_payment_processor_oauth.save
      return render 'oauth_popup_close', :layout => false
    else
      return render 'oauth_popup_code', :layout => false
    end
  end
end

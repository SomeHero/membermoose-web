class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def stripe_connect
    # Delete the code inside of this method and write your own.
    # The code below is to show you where to access the data.
    user = current_user

    payment_processor = PaymentProcessor.where(:name => "Stripe").first

    #parse out oauth_user_id, name, email, token, refresh_token
    oauth_user_id =request.env["omniauth.auth"]["uid"]
    name = request.env["omniauth.auth"]["info"]["name"]
    email = request.env["omniauth.auth"]["info"]["email"]
    api_key = request.env["omniauth.auth"]["info"]["stripe_publishable_key"]
    secret_token = request.env["omniauth.auth"]["credentials"]["token"]
    refresh_token = request.env["omniauth.auth"]["credentials"]["refresh_token"]
    #raise request.env["omniauth.auth"].to_yam

    @account_payment_processor = AccountPaymentProcessor.new({
      account: user.account,
      payment_processor: payment_processor,
      oauth_user_id: oauth_user_id,
      name: name,
      email: email,
      api_key: api_key,
      secret_token: secret_token,
      refresh_token: refresh_token,
      active: true
    })

    if @account_payment_processor.errors.count == 0
      stripe_payment_processors = user.account.account_payment_processors.where(:payment_processor => payment_processor, :active => true)
      stripe_payment_processors.update_all(:active => false)

      user.account.has_connected_stripe = true
      user.account.save!
    end

    if @account_payment_processor.errors.count == 0 && @account_payment_processor.save
      return render 'oauth_popup_close', :layout => false
    else
      return render 'oauth_popup_code', :layout => false
    end
  end
end

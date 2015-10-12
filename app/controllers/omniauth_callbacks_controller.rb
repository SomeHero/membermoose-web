class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def stripe_connect
    # Delete the code inside of this method and write your own.
    # The code below is to show you where to access the data.

    payment_processor = PaymentProcessor.where(:name => "Stripe").first
    binding.pry
    #parse out oauth_user_id, name, email, token, refresh_token
    oauth_user_id =request.env["omniauth.auth"]["uid"]
    name = request.env["omniauth.auth"]["info"]["name"]
    email = request.env["omniauth.auth"]["info"]["email"]
    token = request.env["omniauth.auth"]["info"]["stripe_publishable_key"]
    refresh_token = request.env["omniauth.auth"]["credentials"]["refresh_token"]
    #raise request.env["omniauth.auth"].to_yam

    @account_payment_processor = AccountPaymentProcessor.new({
      account: current_user.account,
      payment_processor: payment_processor,
      oauth_user_id: oauth_user_id,
      name: name,
      email: email,
      token: token,
      refresh_token: refresh_token
    })

    if @account_payment_processor.save
      return render 'oauth_popup_close', :layout => false
    else
      return render 'oauth_popup_code', :layout => false
    end
  end
end

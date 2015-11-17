class Bulls::CardsController < ApplicationController
  before_action :authenticate_user!

  layout 'bulls-dashboard'

  def update
    Rails.logger.info("Attempting to Update Card")
    account = Account.where("LOWER(subdomain) = ?", request.subdomain).first
    user = current_user

    stripe_payment_processor = PaymentProcessor.where(:name => "Stripe").first
    stripe = account.account_payment_processors.where(:payment_processor => stripe_payment_processor).active.first

    card = Card.find(params["id"])
    token = params["card"]["stripe_token"]

    @card = UpdateCard.call(card, token, stripe.secret_token)

    if @card.errors.count == 0
      if params["card"]["default"]
        @card = SetCustomerDefaultCard.call(current_user.account, @card, stripe.secret_token)
        if @card.errors.count == 0
          current_user.account.cards.update_all(:default => false)
          @card.default = true
        end
      end
    end

    respond_to do |format|
      if @card.errors.count == 0 && @card.save
        format.html  { render action: 'index' }
        format.json { render :json => @card.to_json }
      else
        format.html { render action: 'index' }
        format.json { render json: @card.errors, status: :bad_request }
      end
    end
  end

  def destroy
    Rails.logger.info("Attempting to Delete Card")
    account = Account.where("LOWER(subdomain) = ?", request.subdomain).first
    user = current_user

    stripe_payment_processor = PaymentProcessor.where(:name => "Stripe").first
    stripe = account.account_payment_processors.where(:payment_processor => stripe_payment_processor).active.first

    @card = Card.find(params["id"])

    @card = DeleteCard.call(@card, stripe.secret_token)

    respond_to do |format|
      if @card.errors.count == 0
        format.html  { render action: 'index' }
        format.json { render json: {}, status: 200 }
      else
        format.html { render action: 'index' }
        format.json { render json: @card.errors, status: :bad_request }
      end
    end
  end
end

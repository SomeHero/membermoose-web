class Dashboard::CardsController < DashboardController
  layout :determine_layout

  def index
    @cards = current_user.account.cards

    respond_to do |format|
      format.html
      format.json { render :json => @plans.to_json }
    end
  end

  def show
    @card = current_user.account.cards.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render :json => @plan.to_json }
    end
  end

  def create
    account = current_user.account

    stripe_token = params["card"]["stripe_token"]

    @card = AddCard.call(
      current_user.account,
      stripe_token
    )

    if @card.errors.count == 0
      if params["card"]["default"]
        @card = SetCustomerDefaultCard.call(current_user.account, @card)
        if @card.errors.count == 0
          current_user.account.cards.update_all(:default => false)
          @card.default = true
        end
      end
    end

    respond_to do |format|
      if @card.errors.count == 0 && @card.save
        format.html  { render action: 'new' }
        format.json { render :json => @card.to_json }
      else
        format.html { render action: 'new' }
        format.json { render json: @card.errors, status: :bad_request }
      end
    end
  end

  def edit

  end

  def update
    Rails.logger.info("Attempting to Update Card")
    account = current_user.account

    card = Card.find(params["id"])
    token = params["card"]["stripe_token"]

    @card = UpdateCard.call(card, token)

    if @card.errors.count == 0
      if params["card"]["default"]
        @card = SetCustomerDefaultCard.call(current_user.account, @card)
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

    @card = Card.find(params["id"])

    @card = DeleteCard.call(@card)

    respond_to do |format|
      if @card
        format.html  { render action: 'index' }
        format.json { render json: {}, status: 200 }
      else
        format.html { render action: 'index' }
        format.json { render json: @card.errors, status: :bad_request }
      end
    end
  end

  def permitted_params
    params.require(:plan).permit(:id, :name, :description, :amount, :billing_cycle, :billing_interval, :trial_period_days, :terms_and_conditions, :public)
  end

end

class Dashboard::Account::CardsController < DashboardController
  layout :determine_layout

  def index
    @cards = @user.account.cards

    respond_to do |format|
      format.html
      format.json { render :json => @plans.to_json }
    end
  end

  def show
    @card = @user.account.cards.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render :json => @plan.to_json }
    end
  end

  def create
    account = @user.account
    stripe_token = params["stripe_token"]

    @card = AddCard.call(
      account,
      stripe_token
    )

    if @card
      if params["card"]["default"]
        @card = SetCustomerDefaultCard.call(@user.account, @card)
        if @card.errors.count == 0
          @user.account.cards.update_all(:default => false)
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
    account = @user.account

    card = Card.find(params["id"])
    token = params["stripe_token"]

    @card = UpdateCard.call(card, token)

    if @card.errors.count == 0
      if params["card"]["default"]
        @card = SetCustomerDefaultCard.call(@user.account, @card)
        if @card.errors.count == 0
          @user.account.cards.update_all(:default => false)
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

    account = @user.account

    @card = account.cards.find(params["id"])

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

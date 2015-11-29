class GetCustomersWorker

  @queue = :get_customers_worker_queue

  def self.perform(account_id)
    account = Account.find(account_id)
    stripe_payment_processor = PaymentProcessor.where(:name => "Stripe").first
    stripe = account.account_payment_processors.where(:payment_processor => stripe_payment_processor).active.first

    stripe_customers = GetCustomers.call({}, stripe.secret_token)

    stripe_customers.each do |stripe_customer|
      stripe_customer_id = stripe_customer["id"]
      email_address = stripe_customer["email"]
      #pull out the customers sources
      stripe_sources = stripe_customer.sources.data
      #pull out the customers subscriptions
      stripe_subscriptions = stripe_customer.subscriptions.data
      #check to make sure the customer email does not already exists
      #create account with sources and subscriptions
      raw_token, enc_token = Devise.token_generator.generate(
        User, :reset_password_token)
      password = "password" #SecureRandom.hex(32)
      user = User.find_by_email(email_address)

      if !user
        customer_account = Account.new({
          :stripe_customer_id => stripe_customer_id,
          :bull => account,
          :user => User.new({
            email: email_address,
            password: password,
            password_confirmation: password,
            reset_password_token: enc_token,
            reset_password_sent_at: Time.now
          })
        })
      else
        customer_account = user.account
      end

      default_card = nil
      stripe_sources.each do |stripe_source|
        is_default = false
        if stripe_customer["default_source"] == stripe_source["id"]
          is_default = true
        end
        card = Card.new({
            :account => customer_account,
            :external_id => stripe_source["id"],
            :name_on_card => stripe_source["name"],
            :brand => stripe_source["brand"],
            :last4 => stripe_source["last4"],
            :expiration_month => stripe_source["exp_month"],
            :expiration_year => stripe_source["exp_year"],
            :default => is_default
        })
        if is_default
          default_card = card
        end
        customer_account.cards << card
      end

      stripe_subscriptions.each do |stripe_subscription|
        stripe_plan_id = stripe_subscription["plan"]["id"]

        plan = account.plans.find_by(:stripe_id => stripe_plan_id)

        if plan
          subscription = Subscription.new(
            plan: plan,
            account: customer_account,
            card: default_card,
            status: Subscription.statuses[:subscribed]
          )

          customer_account.subscriptions << subscription
        end
      end

      customer_account.save!

      customer_account.subscriptions.each do |subscription|
        begin
          Resque.enqueue(GetNextCustomerInvoiceWorker, subscription.id)
        rescue
          puts "Error #{$!}"
        end
      end

      customer_account.subscriptions.each do |subscription|
        begin
          Resque.enqueue(GetCustomerBillingHistoryWorker, subscription.id)
        rescue
          puts "Error #{$!}"
        end
      end
    end
  end
end

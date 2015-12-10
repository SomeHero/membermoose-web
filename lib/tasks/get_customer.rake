desc "Get Customers"
task :get_customers => [:environment] do
  accounts = Account.where(:role => Account.roles[:bull])
  puts "Found #{accounts.count} accounts"

  accounts.each do |account|
    puts "Found #{account.company_name}"

    next if !account.has_connected_stripe
    next if !account.stripe_secret_key

    results = GetCustomers.call({}, account.stripe_secret_key)

    if !results[0]
      Rails.logger.error "Error Getting Customers #{results[0]}"

      next
    end

    stripe_customers = results[1]

    puts "Found #{stripe_customers.count} customers"

    stripe_customers.each  do |stripe_customer|
      puts "Found #{stripe_customer["email"]}"
      customer_stripe_id = stripe_customer["id"]

      calf = Account.find_by_stripe_customer_id(customer_stripe_id)

      if !calf
        puts "adding calf #{customer_stripe_id}"

        calf = Account.new({
            #:first_name => first_name,
            #:last_name => last_name,
            :role => Account.roles[:calf],
            :bull => account,
            :stripe_customer_id => customer_stripe_id,
            :user => User.new({
              :email => stripe_customer["email"]
            })
        })
      end

      stripe_cards = stripe_customer["sources"]["data"]

      stripe_cards.each do |stripe_card|
        card = Card.find_by_external_id(stripe_card.id)

        if !card
          puts "adding card #{stripe_card.id}"

          card = calf.cards.new({
              :brand => stripe_card["brand"],
              :last4 => stripe_card["last4"],
              :expiration_month => stripe_card["exp_month"],
              :expiration_year => stripe_card["exp_year"],
              :external_id => stripe_card.id
          })
        else
          puts "updating card #{stripe_card.id}"

          card.account = calf
          card.save
        end
      end

      stripe_subscriptions = stripe_customer["subscriptions"]["data"]

      stripe_subscriptions.each do |stripe_subscription|
        subscription = Subscription.find_by_stripe_id(stripe_subscription.id)
        plan = Plan.find_by_stripe_id(stripe_subscription.plan.id)
        card = calf.cards.find_by_external_id(stripe_customer["default_source"])

        if !subscription
          puts "adding subscription #{stripe_subscription.id}"

          calf.subscriptions.new({
            plan: plan,
            status: Subscription.statuses[:subscribed],
            stripe_id: stripe_subscription.id,
            card: card
          })
        end
      end

      calf.save
    end

  end
end

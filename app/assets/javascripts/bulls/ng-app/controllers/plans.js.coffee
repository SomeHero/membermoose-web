@PlansController = angular.module('bullsApp').controller 'PlansController', [
  '$scope'
  'Plan'
  'Subscription'
  'stripe'
  '$window'
  ($scope, Plan, Subscription, stripe, window) ->
    window.scope = $scope

    $scope.account = account
    if$scope.account.payment_processors.length > 0
      stripe.setPublishableKey($scope.account.payment_processors[0].api_key)
    $scope.loading = {
      show_spinner: false
    }
    subscribe_modal = null
    $scope.options = {
      "hashTracking": false,
      "closeOnOutsideClick": false
    }
    $scope.active_step = 1
    $scope.plans_per_row = 3
    $scope.plans = []
    $scope.rows = []
    $scope.row_plans = []
    $scope.credit_card_valid = false
    $scope.credit_card_valid = false
    $scope.subscription = {}
    $scope.payment = {
      card: {}
    }
    $scope.data = {
      available_expiration_monthes:  [
        {id: '1', month: 'January'},
        {id: '2', month: 'February'},
        {id: '3', month: 'March'},
        {id: '4', month: 'April'},
        {id: '5', month: 'May'},
        {id: '6', month: 'June'},
        {id: '7', month: 'July'},
        {id: '8', month: 'August'},
        {id: '9', month: 'September'},
        {id: '10', month: 'October'},
        {id: '11', month: 'November'},
        {id: '12', month: 'December'},
      ],
      available_expiration_years: []
    }
    current_year = new Date().getFullYear()

    i = current_year
    while i <= current_year + 10
      $scope.data.available_expiration_years.push({
        id: '1', year: i
      })
      i++

    $scope.getPlans = () ->
      $scope.loading.show_spinner = true
      Plan.get().then (result) ->
        $scope.plans = result.data
        sortPlans()

        $scope.loading.show_spinner = false

        return

    $scope.subscribe = (plan) ->
      $scope.plan = plan

      if !subscribe_modal
        subscribe_modal = $('[data-remodal-id=subscribe-modal]').remodal($scope.options)

      subscribe_modal.open();

    $scope.charge = (form)  ->
      $scope.credit_card_valid = stripe.card.validateCardNumber($scope.payment.card.number)
      if !$scope.credit_card_valid
        $scope.form_submitted = true
        form['subscription[credit_card_number]'].$invalid = true

        return false

      if form.$valid
        $scope.loading.show_spinner = true
        $scope.payment.plan = $scope.plan.stripeId

        stripe.card.createToken($scope.payment.card).then((token) ->
          console.log 'token created for card ending in ', token.card.last4
          payment = angular.copy($scope.payment)
          payment.card = undefined
          payment.token = token.id

          new Subscription({
            plan_id: $scope.plan.id,
            first_name: $scope.subscription.first_name,
            last_name: $scope.subscription.last_name
            email: $scope.subscription.email,
            stripe_token: token
          }).create().then(
            (response) ->
              $scope.loading.show_spinner = false
              $scope.active_step = 2
            (http)  ->
              $scope.loading.show_spinner = false

              console.log("error creating subscription we should show something")
              errors = http.data
          )
        ).then((subscription) ->
          $scope.loading.show_spinner = false

          console.log 'successfully submitted payment for $', $scope.plan.amount
          return
        ).catch (err) ->
          $scope.loading.show_spinner = false

          if err.type and /^Stripe/.test(err.type)
            console.log 'Stripe error: ', err.message
          else
            console.log 'Other error occurred, possibly with your API', err.message
          return
      else
        $scope.form_submitted = true
        console.log "subsciption form is invalid"

    sortPlans = () ->
      $scope.rows = []
      $scope.row_plans = []

      angular.forEach($scope.plans, (value,index) =>
          $scope.row_plans.push($scope.plans[index])

          if(((index + 1) %% $scope.plans_per_row) == 0)
            $scope.rows.push($scope.row_plans)
            $scope.row_plans = []
          else if (index) >= $scope.plans.length-1
            $scope.rows.push($scope.row_plans)
            $scope.row_plans = []
      )

    $scope.isActiveStep = (step) =>
      if step == $scope.active_step
        return "active"

    $scope.nextClicked = () =>
      $scope.active_step += 1

    $scope.getPlans()

    return
]

PlansController.$inject = ['$scope', 'Plan', 'Subscription', 'stripe', 'window']

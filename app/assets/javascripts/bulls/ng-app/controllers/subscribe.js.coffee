@SubscribeController = angular.module('bullsApp').controller 'SubscribeController', [
  '$scope'
  'Plan'
  'Subscription'
  'plan'
  '$modalInstance'
  'stripe'
  '$window'
  ($scope, Plan, Subscription, plan, $modalInstance, stripe, window) ->
    window.scope = $scope

    $scope.loading = {
      show_spinner: false
    }
    $scope.subscription = {}
    $scope.plan = plan

    $scope.charge = (form)  ->
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

              $modalInstance.close();

              console.log("account updated")
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
        console.log "subsciption form is invalid"
]

SubscribeController.$inject = ['$scope', 'Plan', 'Subscription', 'plan', '$modalInstance', 'stripe', 'window']

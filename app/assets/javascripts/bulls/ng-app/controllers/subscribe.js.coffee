@SubscribeController = angular.module('bullsApp').controller 'SubscribeController', [
  '$scope'
  'Plan'
  'Subscription'
  'plan'
  '$window'
  ($scope, Plan, Subscription, plan, window) ->
    window.scope = $scope

    $scope.subscription = {}
    $scope.plan = plan

    $scope.stripeCallback = (code, result) ->
      if result.error
        console.log result.error
      else
        new Subscription({
          plan_id: $scope.plan.id,
          email: $scope.subscription.email,
          stripe_token: result.id
        }).create();
]

SubscribeController.$inject = ['$scope', 'Plan', 'Subscription', 'plan', 'window']

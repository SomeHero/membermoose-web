@SubscriptionsController = angular.module('dashboardApp').controller 'SubscriptionsController', [
  '$scope'
  'Subscription'
  '$window'
  ($scope, Subscription, window) ->
    $scope.subscription = null
    $scope.subscriptions = []

    Subscription.get().then (subscriptions) ->
      $scope.subscriptions = subscriptions

    $scope.selectSubscription = (event, subscription) ->
      if $scope.subscription == subscription
        $scope.subscription = null
      else
        $scope.subscription = subscription

    $scope.showEditBar = () ->
      return $scope.subscription != null

    $scope.closeEditBar = () ->
      $scope.subscription = null

    return
]

SubscriptionsController.$inject = ['$scope', 'Subscription', 'window']

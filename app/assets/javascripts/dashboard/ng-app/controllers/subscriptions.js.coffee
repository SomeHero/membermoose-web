@SubscriptionsController = angular.module('dashboardApp').controller 'SubscriptionsController', [
  '$scope'
  'Subscription'
  '$window'
  ($scope, Subscription, window) ->
    $scope.subscription = null

    Subscription.get().then (subscriptions) ->
      $scope.subscriptions = subscriptions

    $scope.selectSubscription = (event, subscription) ->
      $scope.subscription = subscription

    $scope.showEditBar = () ->
      return $scope.subscription != null

    $scope.closeEditBar = () ->
      $scope.subscription = null

    return
]

SubscriptionsController.$inject = ['$scope', 'Subscription', 'window']

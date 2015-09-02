@SubscriptionsController = angular.module('dashboardApp').controller 'SubscriptionsController', [
  '$scope'
  'Subscription'
  '$window'
  ($scope, Subscription, window) ->
    Subscription.get().then (subscriptions) ->
      $scope.subscriptions = subscriptions
      
      return
]

SubscriptionController.$inject = ['$scope', 'Subscription', 'window']

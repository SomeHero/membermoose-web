@SubscriptionsController = angular.module('dashboardApp').controller 'SubscriptionsController', [
  '$scope'
  'Subscription'
  '$window'
  ($scope, Subscription, window) ->
    window.scope = $scope
    $scope.selected_subscription = null
    $scope.subscriptions = []
    $scope.totalItems = 100
    $scope.currentPage = 1
    $scope.itemsPerPage = 10
    $scope.isLoading = true

    $scope.pageChanged = () ->
      console.log('Page changed to: ' + $scope.currentPage);
      $scope.isLoading = true
      $scope.getSubscriptions()

    $scope.getSubscriptions = () ->
      Subscription.get({page: $scope.currentPage}).then (subscriptions) ->
        $scope.isLoading = false
        $scope.subscriptions = subscriptions

    $scope.selectSubscription = (event, subscription) ->
      if $scope.selected_subscription == subscription
        $scope.selected_subscription = null
      else
        $scope.selected_subscription = subscription

    $scope.showEditBar = () ->
      return $scope.selected_subscription != null

    $scope.closeEditBar = () ->
      $scope.subscription = null

    $scope.getSubscriptions()

    return
]

SubscriptionsController.$inject = ['$scope', 'Subscription', 'window']

@DashboardController = angular.module('dashboardApp').controller 'DashboardController', [
  '$scope'
  '$stateParams'
  'Plan'
  'Subscription'
  '$window'
  ($scope, $stateParams, Plan, Subscription, window) ->
    window.scope = $scope

    $scope.options = {
      "hashTracking": false,
      "closeOnOutsideClick": false
    }
    $scope.bull = bull
    $scope.account = account

    $scope.getSubscriptions = () ->
      Subscription.get().then((response) ->
          $scope.subscriptions = response.data
      )

    $scope.getPlansForBull = () ->
      Plan.get().then((response) ->
          $scope.bull.plans = response.data
      )

    $scope.getPlansForBull()
    $scope.getSubscriptions()
]
DashboardController.$inject = ['$scope', '$stateParams', 'Plan', 'Subscription', 'window']

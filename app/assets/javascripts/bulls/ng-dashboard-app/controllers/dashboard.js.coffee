@DashboardController = angular.module('dashboardApp').controller 'DashboardController', [
  '$scope'
  '$stateParams'
  'Plan'
  'Subscription'
  '$window'
  ($scope, $stateParams, Plan, Subscription, window) ->
    window.scope = $scope
    currentModal = null

    $scope.options = {
      "hashTracking": false,
      "closeOnOutsideClick": false
    }
    $scope.bull = bull
    $scope.account = account

    $scope.getPublishableKey = () ->
      $scope.bull.payment_processors[0].api_key

    $scope.getSubscriptions = () ->
      Subscription.get().then((response) ->
          $scope.subscriptions = response.data
      )

    $scope.getPlansForBull = () ->
      Plan.get().then((response) ->
          $scope.bull.plans = response.data
      )

    $scope.setCurrentModal = (modal) ->
      currentModal = modal

    $scope.displayLoading = () ->
      return

    $scope.dismissLoading = () ->
      return

    $scope.displaySuccessMessage = () ->
      return

    $scope.displayErrorMessage = () ->
      return

    $scope.dismissModal = () ->
      if currentModal
        currentModal.close()

    $scope.getPlansForBull()
    $scope.getSubscriptions()
]
DashboardController.$inject = ['$scope', '$stateParams', 'Plan', 'Subscription', 'window']

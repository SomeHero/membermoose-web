@DashboardController = angular.module('dashboardApp').controller 'DashboardController', [
  '$scope'
  '$stateParams'
  'Plan'
  'Subscription'
  '$window'
  '$timeout'
  ($scope, $stateParams, Plan, Subscription, window, $timeout) ->
    window.scope = $scope
    currentModal = null

    $scope.loading = {
      showSpinner: false
    }
    $scope.options = {
      "hashTracking": false,
      "closeOnOutsideClick": false
    }
    $scope.showSuccessMessage = false
    $scope.successMessage = ""

    $scope.showErrorMessage = false
    $scope.errorMessage = ""

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
      $scope.loading.showSpinner = true

    $scope.dismissLoading = () ->
      $scope.loading.showSpinner = false

    $scope.displaySuccessMessage = (message) ->
      $scope.successMessage = message
      $scope.showSuccessMessage = true

      $scope.clearMessages()

    $scope.closeSuccessMessage = () ->
      $scope.show_success_message = false

    $scope.displayErrorMessage = (message) ->
      $scope.errorMessage = message
      $scope.showErrorMessage = true

      $scope.clearMessages()

    $scope.closeErrorMessage = () ->
      $scope.showErrorMessage = false

    $scope.clearMessages = () ->
      $timeout(removeMessages, 4000);

    removeMessages = () ->
      $scope.showSuccessMessage = false
      $scope.showErrorMessage = false

    $scope.dismissModal = () ->
      if currentModal
        currentModal.close()

    $scope.getPlansForBull()
    $scope.getSubscriptions()
]
DashboardController.$inject = ['$scope', '$stateParams', 'Plan', 'Subscription', 'window']

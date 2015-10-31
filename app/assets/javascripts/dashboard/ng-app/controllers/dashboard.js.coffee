@DashboardController = angular.module('dashboardApp').controller 'DashboardController', [
  '$scope',
  'Account',
  'Plan',
  '$window',
  '$modal',
  '$timeout'
  'AccountServiceChannel'
  ($scope, Account, Plan, window, $modal, $timeout, AccountServiceChannel) ->
    $scope.user = user
    $scope.plans = []

    $scope.loading = {
      show_spinner: false
    }
    $scope.show_success_message = false
    $scope.success_message = ""

    $scope.show_error_message = false
    $scope.error_message = ""

    $scope.getPlans = () ->
      Plan.get().then (response) ->
        $scope.plans = response.data

    $scope.setMenuItemSelected = (url) ->
      if url == window.location.pathname
        return "selected"

    $scope.close_success_message = () ->
      $scope.show_success_message = false

    $scope.close_error_message = () ->
      $scope.show_error_message = false

    $scope.clear_messages = () ->
      $timeout(remove_messages, 4000);

    remove_messages = () ->
      $scope.show_success_message = false

    onAccountUpdated = () ->
      console.log "Account Updated"

      $scope.getAccount()

    AccountServiceChannel.onAccountUpdated($scope, onAccountUpdated);

    $scope.getPlans()

    return
]

AccountController.$inject = ['$scope', 'Account', 'Plan', 'window', '$modal', '$timeout', 'AccountServiceChannel']

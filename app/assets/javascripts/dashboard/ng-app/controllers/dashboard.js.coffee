@DashboardController = angular.module('dashboardApp').controller 'DashboardController', [
  '$scope',
  'Account',
  'Plan',
  '$window',
  '$modal',
  '$timeout'
  'AccountServiceChannel'
  ($scope, Account, Plan, window, $modal, $timeout, AccountServiceChannel) ->
    $scope.user = new Account(user)
    $scope.plans = []

    $scope.loading = {
      show_spinner: false
    }
    $scope.options = {
      "hashTracking": false,
      "closeOnOutsideClick": false
    }
    $scope.show_success_message = false
    $scope.success_message = ""

    $scope.show_error_message = false
    $scope.error_message = ""

    $scope.set_user = (user) ->
      $scope.user = new Account(user)

    $scope.getPlans = () ->
      Plan.get().then (response) ->
        $scope.plans = response.data

    $scope.setMenuItemSelected = (url) ->
      if url == window.location.pathname
        return "selected"

    $scope.display_loading = () ->
      $scope.loading.show_spinner = true

    $scope.dismiss_loading = () ->
      $scope.loading.show_spinner = false

    $scope.display_success_message = (message) ->
      $scope.success_message = message
      $scope.show_success_message = true

      $scope.clear_messages()

    $scope.close_success_message = () ->
      $scope.show_success_message = false

    $scope.display_error_message = (message) ->
      $scope.error_message = message
      $scope.show_error_message = true

      $scope.clear_messages()

    $scope.close_error_message = () ->
      $scope.show_error_message = false

    $scope.clear_messages = () ->
      $timeout(remove_messages, 4000);

    remove_messages = () ->
      $scope.show_success_message = false
      $scope.show_error_message = false

    onAccountUpdated = () ->
      console.log "Account Updated"

    AccountServiceChannel.onAccountUpdated($scope, onAccountUpdated);

    $scope.getPlans()

    return
]

AccountController.$inject = ['$scope', 'Account', 'Plan', 'window', '$modal', '$timeout', 'AccountServiceChannel']

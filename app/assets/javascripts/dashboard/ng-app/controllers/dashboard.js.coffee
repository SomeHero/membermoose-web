@DashboardController = angular.module('dashboardApp').controller 'DashboardController', [
  '$scope',
  'Account',
  'Plan',
  '$window',
  '$modal'
  ($scope, Account, Plan, window, $modal) ->
    $scope.user = null
    $scope.plans = []

    $scope.show_success_message = false
    $scope.success_message = ""

    $scope.show_error_message = false
    $scope.error_message = ""

    Account.get(58).then (response) ->
      console.log "get account"
      $scope.user = response.data

    Plan.get().then (response) ->
      $scope.plans = response.data

    $scope.setMenuItemSelected = (url) ->
      if url == window.location.pathname
        return "selected"

    $scope.close_success_message = () ->
      $scope.show_success_message = false

    $scope.close_error_message = () ->
      $scope.show_error_message = false

    return
]

AccountController.$inject = ['$scope', 'Account', 'Plan', 'window', '$modal']

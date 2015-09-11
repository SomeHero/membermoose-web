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

    Account.get(1).then (user) ->
      console.log "get account"
      $scope.user = user

    Plan.get().then (plans) ->
      $scope.plans = plans

      sortPlans()

    $scope.openLaunchList = () ->
      modalInstance = $modal.open(
        animation: true
        templateUrl: 'dashboard/ng-app/templates/launchlist/modal2.html'
        controller: 'LaunchListController'
        size: 'lg'
      )

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

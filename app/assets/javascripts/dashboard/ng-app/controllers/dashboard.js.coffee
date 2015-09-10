@DashboardController = angular.module('dashboardApp').controller 'DashboardController', [
  '$scope',
  'Account',
  'Plan',
  '$window',
  '$modal'
  ($scope, Account, Plan, window, $modal) ->
    $scope.user = null
    $scope.plans = []
    $scope.plans_first_row = []
    $scope.rows = []
    $scope.row_plans = []

    $scope.plans_per_row = 4

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

    sortPlans = () ->
      $scope.plans_first_row = []
      $scope.rows = []
      $scope.row_plans = []

      angular.forEach($scope.plans, (value,index) =>
        if(index < $scope.plans_per_row - 1)
          $scope.plans_first_row.push($scope.plans[index])
        else
          if(index + 1 > $scope.plans_per_row && ((index + 1) %% $scope.plans_per_row) == 0)
            $scope.rows.push($scope.row_plans)
            $scope.row_plans = []

          $scope.row_plans.push($scope.plans[index])

          if (index) >= $scope.plans.length - 1
            $scope.rows.push($scope.row_plans)
            $scope.row_plans = []
      )

    return
]

AccountController.$inject = ['$scope', 'Account', 'Plan', 'window', '$modal']

@PlansController = angular.module('bullsApp').controller 'PlansController', [
  '$scope'
  'Plan'
  '$window'
  ($scope, Plan, window) ->
    window.scope = $scope

    $scope.plans_per_row = 4
    $scope.bull = {
      account: {
        company_name: "Bember Boose"
      }
    }
    $scope.plans = []
    $scope.rows = []
    $scope.row_plans = []

    Plan.get().then (plans) ->
      $scope.plans = plans

      sortPlans()

    sortPlans = () ->
      $scope.rows = []
      $scope.row_plans = []

      angular.forEach($scope.plans, (value,index) =>
          $scope.row_plans.push($scope.plans[index])

          if(((index + 1) %% $scope.plans_per_row) == 0)
            $scope.rows.push($scope.row_plans)
            $scope.row_plans = []
          else if (index) >= $scope.plans.length-1
            $scope.rows.push($scope.row_plans)
            $scope.row_plans = []
      )

    return
]

PlansController.$inject = ['$scope', 'Plan', 'window']

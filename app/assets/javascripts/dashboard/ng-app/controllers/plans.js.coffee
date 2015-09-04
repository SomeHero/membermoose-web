@PlansController = angular.module('dashboardApp').controller 'PlansController', [
  '$scope'
  'Plan'
  '$window'
  ($scope, Plan, window) ->
    window.scope = $scope

    $scope.plan = null
    $scope.plans_first_row = []
    $scope.rows = []
    $scope.row_plans = []

    $scope.plans_per_row = 4

    Plan.get().then (plans) ->
      $scope.plans = plans

      sortPlans()

    $scope.editPlan = (plan) ->
      console.log("edit plan")

      $scope.plan = plan

      $scope.plans_per_row = 3
      sortPlans()


    $scope.createPlan = () ->
      console.log("create plan")

    $scope.updatePlan = (plan) ->
      plan.update().then (plan) ->
        console.log("plan updated")

    $scope.showEditBar = () ->
      return $scope.plan != null

    $scope.closeEditBar = () ->
      $scope.plan = null

      $scope.plans_per_row = 4
      sortPlans()

    $scope.setSelectedPlan = (plan) ->
      if(plan == $scope.plan)
        return "selected"
      else
        return ""

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

PlansController.$inject = ['$scope', 'Plan', 'window']

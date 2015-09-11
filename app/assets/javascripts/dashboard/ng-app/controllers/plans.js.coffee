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
    $scope.edit_panel_open = false

    $scope.plans_per_row = 4
    $scope.billing_cycles = [
      'day',
      'week',
      'month',
      'year'
    ];
    Plan.get().then (plans) ->
      $scope.plans = plans

      sortPlans()

    $scope.editPlan = (plan) ->
      console.log("edit plan")

      $scope.edit_panel_open = true
      $scope.plan = angular.copy(plan)

      $scope.plans_per_row = 3
      $scope.$parent.show_success_message = false

      sortPlans()

    $scope.createPlan = () ->
      console.log("create plan")

    $scope.updatePlan = (plan, form) ->
      if form.$valid
        plan.update().then(
          (updated_plan) ->
            angular.forEach($scope.plans, (value,index) =>
              if value.id == updated_plan.id
                $scope.plans[index] = updated_plan
            )
            $scope.closeEditBar()

            $scope.$parent.success_message = "Your plan, " + plan.name + ", was successfully updated."
            $scope.$parent.show_success_message = true

            console.log("plan updated")
          (http)  ->
            console.log("error updating plan")
            errors = http.data

            $scope.$parent.error_message = "Sorry, an unexpected error ocurred.  Please try again."
            $scope.$parent.show_error_message = true
        )

    $scope.showEditBar = () ->
      $scope.edit_panel_open = true

    $scope.closeEditBar = () ->
      $scope.edit_panel_open = false

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

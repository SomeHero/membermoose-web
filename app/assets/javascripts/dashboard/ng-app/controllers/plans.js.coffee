@PlansController = angular.module('dashboardApp').controller 'PlansController', [
  '$scope'
  'Plan'
  '$modal'
  '$window'
  '$timeout'
  ($scope, Plan, $modal, window, $timeout) ->
    window.scope = $scope
    $scope.totalItems = 0
    $scope.currentPage = 1
    $scope.itemsPerPage = 10
    $scope.isLoading = true

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
    $scope.getPlans = () ->
      Plan.setUrl('/dashboard/plans?page={{page}}')
      Plan.get({page: $scope.currentPage}).then (result) ->
        $scope.plans = result.data
        $scope.totalItems = result.originalData.total_items
        $scope.isLoading = false

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

      modalInstance = $modal.open(
        animation: true
        templateUrl: 'dashboard/ng-app/templates/new_plan.html'
        controller: 'CreatePlanController'
        size: 'lg'
      )
      modalInstance.result.then (() ->
        $scope.getPlans()
      ), ->
        $log.info 'Modal dismissed at: ' + new Date

    $scope.updatePlan = (plan, form) ->
      Plan.setUrl('/dashboard/plans')
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
            $scope.clear_messages()

            console.log("plan updated")
          (http)  ->
            console.log("error updating plan")
            errors = http.data

            $scope.$parent.error_message = "Sorry, an unexpected error ocurred.  Please try again."
            $scope.$parent.show_error_message = true
            $scope.clear_message()
        )

    $scope.deletePlan = () ->
      Plan.setUrl('/dashboard/plans')
      $scope.plan.delete().then(
        (response) ->
          $scope.closeEditBar()

          $scope.$parent.success_message = "Your plan, " + $scope.plan.name + ", was successfully deleted."
          $scope.$parent.show_success_message = true
          $scope.clear_messages()

          $scope.getPlans()
          
          console.log("plan deleted")
        (http)  ->
          console.log("error deleting plan")
          errors = http.data

          $scope.$parent.error_message = "Sorry, an unexpected error ocurred.  Please try again."
          $scope.$parent.show_error_message = true
          $scope.clear_message()
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

    $scope.clear_messages = () ->
      $timeout(remove_messages, 4000);

    remove_messages = () ->
      $scope.$parent.show_success_message = false

    $scope.getPlans()

    return
]

PlansController.$inject = ['$scope', 'Plan', '$modal', 'window', '$timeout']

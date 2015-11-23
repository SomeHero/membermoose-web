@UpdatePlanController = angular.module('dashboardApp').controller 'UpdatePlanController', [
  '$scope'
  'Plan'
  '$modal'
  '$http'
  '$window'
  '$timeout'
  'PlansServiceChannel'
  ($scope,  Plan, $modal, $http, window, $timeout, PlansServiceChannel) ->

    init = () ->
      window.scope = $scope

    $scope.updatePlan = (plan, form) ->
      Plan.setUrl('/dashboard/plans')
      if form.$valid
        $scope.display_loading()
        $scope.selected_plan.update().then(
          (updated_plan) ->
            angular.forEach($scope.plans, (value,index) =>
              if value.id == updated_plan.id
                $scope.plans[index] = updated_plan
            )
            $scope.closeEditBar()

            message = "Your plan, " + plan.name + ", was successfully updated."
            $scope.display_success_message(message)

            $scope.dismiss_loading()

            PlansServiceChannel.onPlansUpdated()
          (http)  ->
            errors = http.data

            message = errors
            $scope.display_error_message(message)
        )

    init()
]

UpdatePlanController.$inject = ['$scope', 'Plan', '$modal', '$http', 'window', '$timeout', 'PlansServiceChannel']

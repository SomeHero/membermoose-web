@DeletePlanController = angular.module('dashboardApp').controller 'DeletePlanController', [
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

    $scope.deletePlanCancelled = () ->
      delete_plan_modal.close()

    $scope.deletePlan = () ->
      $scope.display_loading()

      Plan.setUrl('/dashboard/plans')
      $scope.selected_plan.delete().then(
        (response) ->
          $scope.dismiss_loading()
          $scope.closeEditBar()

          message = "Your plan, " + $scope.plan.name + ", was successfully deleted."
          $scope.display_success_message(message)

          $scope.getPlans()

          delete_plan_modal.close()
        (http)  ->
          $scope.dismiss_loading()

          errors = http.data

          message = errors
          $scope.display_error_message(message)
      )

    init()
]

DeletePlanController.$inject = ['$scope', 'Plan', '$modal', '$http', 'window', '$timeout', 'PlansServiceChannel']

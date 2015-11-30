@DeletePlanController = angular.module('dashboardApp').controller 'DeletePlanController', [
  '$scope'
  '$state'
  '$stateParams'
  'Plan'
  '$modal'
  '$http'
  '$window'
  '$timeout'
  'PlansServiceChannel'
  ($scope, $state, $stateParams, Plan, $modal, $http, window, $timeout, PlansServiceChannel) ->

    init = () ->
      window.scope = $scope

      if !$stateParams.plan
        $state.go('dashboard.plans')

        return

      $scope.plan = $stateParams.plan

      if !modal
        modal = $('[data-remodal-id=delete-plan-modal]').remodal($scope.options)

      $scope.setCurrentModal(modal)
      modal.open()

    $scope.deletePlanCancelled = () ->
      $scope.dismissModal()

    $scope.deletePlan = () ->
      $scope.display_loading()

      Plan.setUrl('/dashboard/plans')
      new Plan($scope.plan).delete().then(
        (response) ->
          $scope.dismiss_loading()
          $scope.closeEditBar()

          message = "Your plan, " + $scope.plan.name + ", was successfully deleted."
          $scope.display_success_message(message)

          $scope.getPlans()

          $scope.dismissModal()
        (http)  ->
          $scope.dismiss_loading()

          errors = http.data

          message = errors
          $scope.display_error_message(message)
      )

    init()
]

DeletePlanController.$inject = ['$scope', '$state', '$stateParams', 'Plan', '$modal', '$http', 'window', '$timeout', 'PlansServiceChannel']

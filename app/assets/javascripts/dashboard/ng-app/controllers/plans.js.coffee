@PlansController = angular.module('dashboardApp').controller 'PlansController', [
  '$scope'
  'Plan'
  '$window'
  ($scope, Plan, window) ->

    $scope.plan = null

    Plan.get().then (plans) ->
      $scope.plans = plans

    $scope.editPlan = (plan) ->
      console.log("edit plan")

      $scope.plan = plan

    $scope.createPlan = () ->
      console.log("create plan")

    $scope.updatePlan = (plan) ->
      plan.update().then (plan) ->
        console.log("plan updated")

    $scope.showEditBar = () ->
      return $scope.plan != null

    $scope.closeEditBar = () ->
      $scope.plan = null

    $scope.setSelectedPlan = (plan) ->
      if(plan == $scope.plan)
        return "selected"
      else
        return ""

    return
]

PlansController.$inject = ['$scope', 'Plan', 'window']

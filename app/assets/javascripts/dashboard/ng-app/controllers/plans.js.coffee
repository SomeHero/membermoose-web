angular.module('dashboardApp').controller 'PlansController', [
  '$scope'
  'Plan'
  '$window'
  ($scope, Plan, window) ->
    Plan.get().then (plans) ->
      $scope.plans = plans

      return
]

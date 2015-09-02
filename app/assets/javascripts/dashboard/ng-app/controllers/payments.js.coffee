angular.module('dashboardApp').controller 'PaymentsController', [
  '$scope'
  'Plan'
  '$window'
  ($scope, Payments, window) ->
    Plan.get().then (payments) ->
      $scope.payments = payments

      return
]

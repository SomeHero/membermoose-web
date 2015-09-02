@PaymentController = angular.module('dashboardApp').controller 'PaymentsController', [
  '$scope'
  'Payment'
  '$window'
  ($scope, Payments, window) ->
    Payment.get().then (payments) ->
      $scope.payments = payments

      return
]

PaymentController.$inject = ['$scope', 'Payment', 'window']

@PaymentController = angular.module('dashboardApp').controller 'PaymentsController', [
  '$scope'
  'Payment'
  '$window'
  ($scope, Payment, window) ->
    $scope.payment = null
    $scope.payments = []

    Payment.get().then (payments) ->
      $scope.payments = payments

    $scope.selectPayment = (event, payment) ->
      if $scope.payment == payment
        $scope.payment = null
      else
        $scope.payment = payment

    $scope.showEditBar = () ->
      return $scope.payment != null

    $scope.closeEditBar = () ->
      $scope.subscription = null

    return
]

PaymentController.$inject = ['$scope', 'Payment', 'window']

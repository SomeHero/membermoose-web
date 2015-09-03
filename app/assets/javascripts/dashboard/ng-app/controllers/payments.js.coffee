@PaymentController = angular.module('dashboardApp').controller 'PaymentsController', [
  '$scope'
  'Payment'
  '$window'
  ($scope, Payments, window) ->
    $scope.payment = null
    
    Payment.get().then (payments) ->
      $scope.payments = payments

    $scope.showEditBar = () ->
      return true

    $scope.closeEditBar = () ->
      return false

    return
]

PaymentController.$inject = ['$scope', 'Payment', 'window']

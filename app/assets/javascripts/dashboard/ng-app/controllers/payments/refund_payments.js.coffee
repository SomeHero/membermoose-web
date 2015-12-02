@RefundPaymentsController = angular.module('dashboardApp').controller 'RefundPaymentsController', [
  '$scope'
  'Payment'
  '$window'
  '$timeout'
  '$http'
  ($scope, Payment, window, $timeout, $http) ->
    init = () ->
      window.scope = $scope

      if !modal
        modal = $('[data-remodal-id=refund-payment-modal]').remodal($scope.options)

      modal.open()
      $scope.setCurrentModal(modal)


    $scope.refundPaymentCancel = () ->
      $scope.dismissModal()

    $scope.refundPaymentSubmit = () ->
      $scope.loading.show_spinner = true
      $http.post('/dashboard/payments/' + $scope.selected_payment.id  + '/refund').then(
        (response) ->
          $scope.selected_payment.status = "Refunded"

          message = "The payment was successfully refunded."
          $scope.display_success_message(message)

          $scope.dismiss_loading()
          $scope.dismissModal()

          $scope.closeEditBar()
        (http)  ->
          errors = http.data

          message = "Sorry, an unexpected error ocurred.  Please try again."
          $scope.display_error_message(message)

          $scope.dismiss_loading()
      )

    init()
]

RefundPaymentsController.$inject = ['$scope', 'Plan', '$modal', '$http', 'window', '$timeout', 'PlansServiceChannel']

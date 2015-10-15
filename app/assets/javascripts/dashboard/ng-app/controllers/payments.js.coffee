@PaymentController = angular.module('dashboardApp').controller 'PaymentsController', [
  '$scope'
  'Payment'
  '$window'
  '$timeout'
  ($scope, Payment, window, $timeout) ->
    window.scope = $scope
    $scope.selected_payment = null
    $scope.payments = []
    $scope.totalItems = 0
    $scope.currentPage = 1
    $scope.itemsPerPage = 10
    $scope.isLoading = true

    $scope.pageChanged = () ->
      console.log('Page changed to: ' + $scope.currentPage);
      $scope.isLoading = true
      $scope.getPayments()

    $scope.getPayments = () ->
      Payment.setUrl('/dashboard/payments?page={{page}}')
      Payment.get({page: $scope.currentPage}).then (result) ->
        $scope.payments = result.data
        $scope.totalItems = result.originalData.total_items
        $scope.isLoading = false

    $scope.selectPayment = (event, payment) ->
      if $scope.selected_payment == payment
        $scope.selected_payment = null
      else
        $scope.selected_payment = payment

    $scope.showEditBar = () ->
      return $scope.selected_payment != null

    $scope.closeEditBar = () ->
      $scope.selected_payment = null

    $scope.clear_messages = () ->
      $timeout(remove_messages, 4000);

    remove_messages = () ->
      $scope.$parent.show_success_message = false

    $scope.getPayments()

    return
]

PaymentController.$inject = ['$scope', 'Payment', 'window', '$timeout']

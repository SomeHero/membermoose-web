@PaymentController = angular.module('dashboardApp').controller 'PaymentsController', [
  '$scope'
  'Payment'
  '$window'
  '$timeout'
  '$http'
  ($scope, Payment, window, $timeout, $http) ->
    window.scope = $scope
    $scope.selected_payment = null
    $scope.payments = []
    $scope.totalItems = 0
    $scope.searchItems = 0
    $scope.currentPage = 1
    $scope.itemsPerPage = 10
    $scope.isLoading = true
    $scope.loading = {
      show_spinner: false
    }
    $scope.display_search = false
    $scope.search = {
      from_date: null,
      to_date: null
    }
    $scope.price_slider = {
      min: 0,
      max: 1000,
      ceil: 1000,
      floor: 0
    }
    $scope.pageChanged = () ->
      console.log('Page changed to: ' + $scope.currentPage);
      $scope.isLoading = true
      $scope.getPayments()

    $scope.getPayments = () ->
      Payment.setUrl('/dashboard/payments?page={{page}}')
      Payment.get({page: $scope.currentPage}).then (result) ->
        $scope.payments = result.data
        $scope.totalItems = result.originalData.total_items
        $scope.searchItems = $scope.totalItems
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

    $scope.search = () ->
      Payment.setUrl('/dashboard/payments')
      Payment.query({
          from_date: $scope.search.from_date,
          to_date: $scope.search.to_date,
          firstName: $scope.search.first_name,
          lastName: $scope.search.last_name,
          from_amount: $scope.price_slider.min,
          to_amount: $scope.price_slider.max
      }).then (result) ->
        $scope.payments = result.data
        $scope.totalItems = result.originalData.total_items
        $scope.searchItems = $scope.totalItems
        $scope.isLoading = false

    $scope.getSearchCount = () ->
      Payment.setUrl('/dashboard/payments/count')
      Payment.query({
          from_date: $scope.search.from_date,
          to_date: $scope.search.to_date,
          firstName: $scope.search.first_name,
          lastName: $scope.search.last_name,
          from_amount: $scope.price_slider.min,
          to_amount: $scope.price_slider.max
      }).then (result) ->
        $scope.searchItems = result.data.count

    $scope.toggle_search = () ->
      if $scope.display_search
        $scope.display_search = false
      else
        $scope.display_search = true

    $scope.refund_payment_clicked = () ->
      options = {
        "hashTracking": false,
        "closeOnOutsideClick": false
      }
      window.modal = $('[data-remodal-id=refund-payment-modal]').remodal(options)
      window.modal.open();

    $scope.refund_payment_submit = () ->
      $scope.loading.show_spinner = true
      $http.post('/dashboard/payments/' + $scope.selected_payment.id  + '/refund').then(
        () ->
          $scope.closeEditBar()

          $scope.$parent.success_message = "The payment was successfully refunded."
          $scope.$parent.show_success_message = true
          $scope.clear_messages()

          $scope.loading.show_spinner = false
          window.modal.close()

          $scope.selected_subscription.status = "Cancelled"
          $scope.closeEditBar()

          console.log("payment refunded")
        (http)  ->
          console.log("error refunding payment")
          errors = http.data

          $scope.$parent.error_message = "Sorry, an unexpected error ocurred.  Please try again."
          $scope.$parent.show_error_message = true
          $scope.clear_messages()

          $scope.loading.show_spinner = false
          window.modal.close()
      )

    $scope.clear_messages = () ->
      $timeout(remove_messages, 4000);

    remove_messages = () ->
      $scope.$parent.show_success_message = false

    $scope.getPayments()

    return
]

PaymentController.$inject = ['$scope', 'Payment', 'window', '$timeout', '$http']

@CancelSubscriptionController = angular.module('dashboardApp').controller 'CancelSubscriptionController', [
  '$scope'
  '$state'
  '$stateParams'
  'Subscription'
  'stripe'
  '$window'
  ($scope, $state, $stateParams, Subscription, stripe, window) ->
    init = () ->
      window.scope = $scope

      if !$stateParams.subscription
        $state.go('dashboard.subscriptions')

        return

      $scope.subscription = $stateParams.subscription

      if !modal
        modal = $('[data-remodal-id=cancel-subscription-modal]').remodal($scope.options)

      $scope.setCurrentModal(modal)
      modal.open()

    $scope.cancelSubscriptionSubmit = () ->
      Subscription.setUrl('/dashboard/subscriptions')

      $scope.display_loading()
      new Subscription($scope.subscription).delete().then(
        () ->
          $scope.subscription.status = "cancelled"
          angular.forEach $scope.subscriptions, ((subscription, index) ->
            if subscription.id == $scope.subscription.id
              scope.subscriptions[index] = $scope.subscription

              return
          )
          message = "The subscription was successfully cancelled."
          $scope.display_success_message(message)

          $scope.dismiss_loading()
          $scope.dismissModal()

          $scope.closeEditBar()
        (http)  ->
          $scope.dismiss_loading()

          errors = http.data

          message = "Sorry, an unexpected error ocurred.  Please try again."
          $scope.display_error_message(message)
      )

    init()
]

CancelSubscriptionController.$inject = ['$scope', '$state', '$stateParams', 'Subscription', 'stripe', 'window']

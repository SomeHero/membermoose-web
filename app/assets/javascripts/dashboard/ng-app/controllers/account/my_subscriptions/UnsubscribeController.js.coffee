@UnsubscribeController = angular.module('dashboardApp').controller 'UnsubscribeController', [
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
        $state.go('dashboard.my_subscriptions')

      $scope.subscription = $stateParams.subscription

      if !modal
        modal = $('[data-remodal-id=cancel-subscription-modal]').remodal($scope.options)

      $scope.setCurrentModal(modal)
      modal.open()

    $scope.cancelSubscriptionSubmit = () ->
      Subscription.setUrl('/dashboard/subscriptions')

      $scope.display_loading()
      $scope.subscription.delete().then(
        () ->
          $scope.subscription.status = "Cancelled"

          message = "The subscription was successfully deleted."
          $scope.display_success_message(message)

          $scope.dismiss_loading()
          $scope.dismissModal()
        (http)  ->
          errors = http.data

          message = "Sorry, an unexpected error ocurred.  Please try again."
          $scope.display_error_message(message)

          $scope.dismissLoading()
      )

    init()
]

UnsubscribeController.$inject = ['$scope', '$state', '$stateParams', 'Subscription', 'stripe', 'window']

@SubscriptionsController = angular.module('dashboardApp').controller 'SubscriptionsController', [
  '$scope'
  '$stateParams'
  'Subscription'
  '$window'
  ($scope, $stateParams, Subscription, window) ->
    window.scope = $scope
    cancelSubscriptionModal = null
    $scope.selectedSubscription = {}

    $scope.cancelSubscriptionClicked = (subscription) ->
      $scope.selectedSubscription = subscription

      if !cancelSubscriptionModal
        cancelSubscriptionModal = $('[data-remodal-id=cancel-subscription-modal]').remodal($scope.options)

      cancelSubscriptionModal.open()

    $scope.cancelSubscriptionSubmit = () ->
      Subscription.setUrl('/bulls/subscriptions')
      #$scope.display_loading()
      $scope.selectedSubscription.delete().then(
        () ->
          $scope.selectedSubscription.status = "Cancelled"
          #$scope.closeEditBar()

          #message = "The subscription was successfully deleted."
          #$scope.display_success_message(message)

          #$scope.dismiss_loading()
          cancelSubscriptionModal.close()
        (http)  ->
          errors = http.data

          #message = "Sorry, an unexpected error ocurred.  Please try again."
          #$scope.display_error_message(message)

          #$scope.dismiss_loading()
      )

    $scope.getSubscriptions = () ->
      Subscription.get().then((response) ->
          $scope.subscriptions = response.data
      )

    $scope.getSubscriptions()
]
SubscriptionsController.$inject = ['$scope', '$stateParams', 'Subscription', 'window']

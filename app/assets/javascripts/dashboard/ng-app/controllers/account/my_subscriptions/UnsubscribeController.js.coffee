@UnsubscribeController = angular.module('dashboardApp').controller 'UnsubscribeController', [
  '$scope'
  '$state'
  '$stateParams'
  'MySubscription'
  'stripe'
  '$window'
  ($scope, $state, $stateParams, MySubscription, stripe, window) ->
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
      MySubscription.setUrl('/dashboard/my_subscriptions')

      $scope.display_loading()
      new MySubscription($scope.subscription).delete().then(
        () ->
          $scope.subscription.status = "cancelled"
          angular.forEach $scope.user.account.subscriptions, ((subscription, index) ->
            if subscription.id == $scope.subscription.id
              $scope.user.account.subscriptions[index] = $scope.subscription

              return
          )
          message = "The subscription was successfully cancelled."
          $scope.display_success_message(message)

          $scope.dismiss_loading()
          $scope.dismissModal()
        (http)  ->
          errors = http.data

          message = "Sorry, an unexpected error ocurred.  Please try again."
          $scope.display_error_message(message)

          $scope.dismiss_loading()
      )

    init()
]

UnsubscribeController.$inject = ['$scope', '$state', '$stateParams', 'MySubscription', 'stripe', 'window']

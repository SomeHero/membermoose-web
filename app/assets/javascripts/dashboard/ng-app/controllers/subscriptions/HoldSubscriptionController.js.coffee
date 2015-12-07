@HoldSubscriptionController = angular.module('dashboardApp').controller 'HoldSubscriptionController', [
  '$scope'
  '$state'
  '$stateParams'
  'Subscription'
  '$http'
  '$window'
  ($scope, $state, $stateParams, Subscription, $http, $window) ->
    init = () ->
      $window.scope = $scope
      if !$stateParams.subscription
        $state.go('dashboard.subscriptions')

        return

      $scope.subscription = $stateParams.subscription

      if !modal
        modal = $('[data-remodal-id=hold-subscription-modal]').remodal($scope.options)

      $scope.setCurrentModal(modal)
      modal.open()

    $scope.holdSubscriptionSubmit = () ->
      if $scope.subscription == null
        return

      $scope.loading.show_spinner = true

      $http.post('/dashboard/subscriptions/' + $scope.selected_subscription.id  + '/hold').then(
        (response) ->
          updated_subscription = new Subscription(response.data)

          angular.forEach $scope.subscriptions, ((subscription, index) ->
            if subscription.id == updated_subscription.id
              $scope.subscriptions[index] = updated_subscription

              return
          )

          message = "The subscription was successfully put on hold."
          $scope.display_success_message(message)

          $scope.dismiss_loading()
          $scope.dismissModal()

          $scope.closeEditBar()
        (http)  ->
          errors = http.data

          message = "Sorry, an unexpected error ocurred. " + errors.message + "."
          $scope.display_error_message(message)

          $scope.dismiss_loading()
      )

    init()
]

HoldSubscriptionController.$inject = ['$scope', '$state', '$stateParams', 'Subscription', '$http', 'window']

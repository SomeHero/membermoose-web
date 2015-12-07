@HoldSubscriptionController = angular.module('dashboardApp').controller 'HoldSubscriptionController', [
  '$scope'
  '$state'
  '$stateParams'
  'Subscription'
  'stripe'
  '$http'
  '$window'
  ($scope, $state, $stateParams, Subscription, stripe, $http, $window) ->
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
      console.log "hold subscription"

      $scope.dismissModal()

    init()
]

HoldSubscriptionController.$inject = ['$scope', '$state', '$stateParams', 'Subscription', 'stripe', 'window']

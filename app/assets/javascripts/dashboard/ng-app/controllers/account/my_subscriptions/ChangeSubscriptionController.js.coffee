@ChangeSubscriptionController = angular.module('dashboardApp').controller 'ChangeSubscriptionController', [
  '$scope'
  '$stateParams'
  'Subscription'
  'stripe'
  '$window'
  ($scope, $stateParams, Subscription, stripe, window) ->
    init = () ->
      window.scope = $scope
      if !$stateParams.subscription
        $state.go('dashboard.my_subscriptions')

      $scope.subscription = $stateParams.subscription

      if !modal
        modal = $('[data-remodal-id=change-subscription-modal]').remodal($scope.options)

      $scope.setCurrentModal(modal)
      modal.open()

    init()
]

ChangeSubscriptionController.$inject = ['$scope', '$stateParams', 'Subscription', 'stripe', 'window']

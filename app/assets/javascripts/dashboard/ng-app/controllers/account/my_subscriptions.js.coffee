@MySubscriptionsController = angular.module('dashboardApp').controller 'MySubscriptionsController', [
  '$scope'
  '$state'
  '$stateParams'
  'Subscription'
  '$window'
  '$http'
  ($scope, $state, $stateParams, Subscription, window, $http) ->
    init = () ->
      window.scope = $scope
      cancelSubscriptionModal = null
      changeSubscriptionModal = null
      $scope.selectedSubscription = {}
      $scope.selectedPlan = {}

      $scope.init()

      $(document).on 'closed', '.remodal', (e) ->
        # Reason: 'confirmation', 'cancellation'
        if $state.current.name.indexOf("my_subscriptions") > -1
          $state.go('dashboard.my_subscriptions')

    $scope.filterSubscribedPlan = (plan) ->
      return plan.id != $scope.selectedSubscription.plan.id

    init()
]
MySubscriptionsController.$inject = ['$scope', '$state', '$stateParams', 'Subscription', 'window', '$http']

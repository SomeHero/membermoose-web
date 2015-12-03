@ChangePlanController = angular.module('dashboardApp').controller 'ChangePlanController', [
  '$scope'
  '$state'
  '$stateParams'
  'Subscription'
  'stripe'
  '$http'
  '$window'
  ($scope, $state, $stateParams, Subscription, stripe, $http, window) ->
    init = () ->
      window.scope = $scope
      if !$stateParams.subscription
        $state.go('dashboard.subscriptions')

        return

      $scope.subscription = $stateParams.subscription

      if !modal
        modal = $('[data-remodal-id=change-plan-modal]').remodal($scope.options)

      $scope.setCurrentModal(modal)
      modal.open()

    $scope.filterSubscribedPlan = (plan) ->
      plan.id != $scope.selected_subscription.plan.id

    $scope.selectPlan = (plan) ->
      $scope.selected_plan = plan

    $scope.isPlanSelected = (plan) ->
        if $scope.selected_plan == plan
          return true

        return false

    $scope.changePlanSubmit = () ->
      if $scope.selected_plan == null
        return

      $scope.loading.show_spinner = true

      params = {
          plan_id: $scope.selected_plan.id
      }
      $http.post('/dashboard/subscriptions/' + $scope.selected_subscription.id  + '/change', params).then(
        (response) ->
          new_subscription = new Subscription(response.data)

          angular.forEach $scope.subscriptions, ((subscription, index) ->
            if subscription.id == new_subscription.id
              scope.subscriptions[index] = new_subscription

              return
          )

          message = "The subscription was successfully changed."
          $scope.display_success_message(message)

          $scope.dismiss_loading()
          $scope.dismissModal()

          $scope.closeEditBar()
        (http)  ->
          errors = http.data

          message = "Sorry, an unexpected error ocurred.  Please try again."
          $scope.display_error_message(message)

          $scope.dismiss_loading()
      )

    init()
]

ChangePlanController.$inject = ['$scope', '$state', '$stateParams', 'Subscription', 'stripe', '$http', 'window']

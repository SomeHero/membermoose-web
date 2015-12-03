@ChangeSubscriptionController = angular.module('dashboardApp').controller 'ChangeSubscriptionController', [
  '$scope'
  '$state'
  '$stateParams'
  'Subscription'
  'BullPlan'
  'stripe'
  '$window'
  '$http'
  ($scope, $state, $stateParams, Subscription, BullPlan, stripe, window, $http) ->
    init = () ->
      window.scope = $scope
      if !$stateParams.subscription
        $state.go('dashboard.my_subscriptions')

      $scope.subscription = $stateParams.subscription
      $scope.currentStep = 1
      $scope.currentPage = 1
      $scope.selectedPlan = null

      if !modal
        modal = $('[data-remodal-id=change-subscription-modal]').remodal($scope.options)

      $scope.setCurrentModal(modal)
      modal.open()

      $scope.getPlans()

    $scope.isCurrentStep = (step) ->
      if step == $scope.currentStep
        return true

      return false

    $scope.nextStepClicked = () ->
      if $scope.currentStep == 1
        if $scope.selectedPlan == null
          return

      $scope.currentStep += 1

    $scope.previousStepClicked = () ->
      $scope.currentStep -= 1

    $scope.getPlans = () ->
      $scope.loading.show_spinner = true

      BullPlan.get({page: $scope.currentPage}).then (result) ->
        $scope.plans = result.data
        $scope.totalItems = result.originalData.total_items

        $scope.dismiss_loading()


    $scope.filterSubscribedPlan = (plan) ->
      plan.id != $scope.subscription.plan.id

    $scope.selectPlan = (plan) ->
      $scope.selectedPlan = plan

    $scope.isPlanSelected = (plan) ->
        if $scope.selectedPlan == plan
          return true

        return false

    $scope.changePlanSubmit = () ->
      if $scope.selectedPlan == null
        return

      $scope.loading.show_spinner = true

      params = {
          plan_id: $scope.selectedPlan.id
      }
      $http.post('/dashboard/subscriptions/' + $scope.subscription.id  + '/change', params).then(
        (response) ->
          new_subscription = new Subscription(response.data)

          angular.forEach $scope.user.account.subscriptions, ((subscription, index) ->
            if subscription.id == new_subscription.id
              $scope.user.account.subscriptions[index] = new_subscription

              return
          )

          message = "The subscription was successfully changed."
          $scope.display_success_message(message)

          $scope.dismiss_loading()
          $scope.dismissModal()

        (http)  ->
          errors = http.data

          message = "Sorry, an unexpected error ocurred.  Please try again."
          $scope.display_error_message(message)

          $scope.dismiss_loading()
          $scope.dismissModal()
      )


    init()
]

ChangeSubscriptionController.$inject = ['$scope', '$state', '$stateParams', 'Subscription', 'BullPlan', 'stripe', 'window', '$http']

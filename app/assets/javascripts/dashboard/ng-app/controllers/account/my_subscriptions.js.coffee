@MySubscriptionsController = angular.module('dashboardApp').controller 'MySubscriptionsController', [
  '$scope'
  '$stateParams'
  'Subscription'
  '$window'
  '$http'
  ($scope, $stateParams, Subscription, window, $http) ->
    window.scope = $scope
    cancelSubscriptionModal = null
    changeSubscriptionModal = null
    $scope.selectedSubscription = {}
    $scope.selectedPlan = {}

    $scope.cancelSubscriptionClicked = (subscription) ->
      $scope.selectedSubscription = subscription

      if !cancelSubscriptionModal
        cancelSubscriptionModal = $('[data-remodal-id=cancel-subscription-modal]').remodal($scope.options)

      $scope.setCurrentModal(cancelSubscriptionModal)
      cancelSubscriptionModal.open()

    $scope.cancelSubscriptionSubmit = () ->
      Subscription.setUrl('/bulls/subscriptions')

      $scope.displayLoading()
      $scope.selectedSubscription.delete().then(
        () ->
          $scope.selectedSubscription.status = "Cancelled"

          message = "The subscription was successfully deleted."
          $scope.displaySuccessMessage(message)

          $scope.dismissLoading()
          cancelSubscriptionModal.close()
        (http)  ->
          errors = http.data

          message = "Sorry, an unexpected error ocurred.  Please try again."
          $scope.displayErrorMessage(message)

          $scope.dismissLoading()
      )

    $scope.changeSubscriptionClicked = (subscription) ->
      $scope.selectedSubscription = subscription

      if !changeSubscriptionModal
        changeSubscriptionModal = $('[data-remodal-id=change-subscription-modal]').remodal($scope.options)

      $scope.setCurrentModal(changeSubscriptionModal)
      changeSubscriptionModal.open()

    $scope.changePlanSelect = (plan) ->
      $scope.selectedPlan = plan

    $scope.changePlanSubmit = () ->
      if $scope.selected_plan == null
        return

      $scope.loading.showSpinner = true

      params = {
          plan_id: $scope.selectedPlan.id
      }
      $http.post('/bulls/subscriptions/' + $scope.selectedSubscription.id  + '/change', params).then(
        (response) ->
          new_subscription = new Subscription(response.data)

          angular.forEach $scope.subscriptions, ((subscription, index) ->
            if subscription.id == new_subscription.id
              $scope.subscriptions[index] = new_subscription

              return
          )

          message = "The subscription was successfully changed."
          $scope.displaySuccessMessage(message)

          $scope.dismissLoading()
          changeSubscriptionModal.close()

        (http)  ->
          errors = http.data

          message = "Sorry, an unexpected error ocurred.  Please try again."
          $scope.displayErrorMessage(message)

          $scope.dismissLoading()
      )

    $scope.filterSubscribedPlan = (plan) ->
      return plan.id != $scope.selectedSubscription.plan.id

    $scope.init()
]
MySubscriptionsController.$inject = ['$scope', '$stateParams', 'Subscription', 'window', '$http']

@ConnectStripeController = angular.module('dashboardApp').controller 'ConnectStripeController', [
  '$scope'
  'Plan'
  '$window'
  'Account'
  '$timeout'
  '$interval'
  'fileReader'
  'stripe'
  'Upload'
  'AccountServiceChannel'
  'PlansServiceChannel'
  '$http'
  ($scope, Plan, window, Account, $timeout, $interval, fileReader, stripe, Upload, AccountServiceChannel, PlansServiceChannel, $http) ->
    oAuthModal = null
    init = () ->
      window.scope = $scope

      $scope.timer = null
      if !connect_stripe_modal
        connect_stripe_modal = $('[data-remodal-id=stripe-modal]').remodal($scope.options)

      connect_stripe_modal.open()
      $scope.setCurrentModal(connect_stripe_modal)

    $scope.stripe_connect = () ->
      openUrl = "/users/auth/stripe_connect"
      window.$windowScope = $scope
      oAuthModal = window.open(openUrl, "Authenticate Account", "width=500, height=500")

      $scope.timer = $interval(checkOauthPopup, 1000);

      true

    checkOauthPopup = () ->
      if !oAuthModal.window
        $scope.handlePopupAuthentication()

        if angular.isDefined($scope.timer)
          $interval.cancel $scope.timer


    $scope.handlePopupAuthentication = () ->
      $scope.applyNetwork()

    $scope.applyNetwork = () ->
      $scope.user.account.hasConnectedStripe = true

      AccountServiceChannel.accountUpdated()

    $scope.getPlansClicked = () ->
      $scope.display_loading()

      $http.post('/dashboard/plans/get_stripe_plans').then(
        (response) ->
          $scope.dismiss_loading()
          $scope.form_submitted = false

          $scope.importPlans = response.data.plans
          $scope.dismissModal()
        (http)  ->
          $scope.dismiss_loading()

      )

    $scope.importPlansClicked = () ->
      $scope.display_loading()

      $http.post('/dashboard/plans/get_stripe_plans').then(
        (response) ->
          plans = response.data.plans
          plan_ids = []
          angular.forEach(plans, (plan,index) =>
            plan_ids.push(plan.id)
          )
          params = {
            plans: plan_ids
          }
          $http.post('/dashboard/plans/import_stripe_plans', params).then(
            (response) ->
              $scope.dismiss_loading()
              $scope.form_submitted = false

              message = "Your successfully updated your password."
              $scope.display_success_message(message)
            (http)  ->
              $scope.dismiss_loading()

              message = http.statusText
              $scope.display_error_message(message)
          )
        )

    init()
]

ConnectStripeController.$inject = ['$scope', 'Plan', '$window', 'Account', '$timeout', '$interval', 'fileReader', 'stripe', 'Upload', 'AccountServiceChannel', 'PlansServiceChannel', '$http']

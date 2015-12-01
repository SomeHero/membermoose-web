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
      $scope.currentStep = 1
      if $scope.user.account.hasConnectedStripe
          $scope.currentStep = 2
      $scope.plans = []
      $scope.plansToImport = []

      $scope.timer = null
      if !connect_stripe_modal
        connect_stripe_modal = $('[data-remodal-id=stripe-modal]').remodal($scope.options)

      connect_stripe_modal.open()
      $scope.setCurrentModal(connect_stripe_modal)

    $scope.isActiveStep = (step) ->
      if !$scope.user.account.hasConnectedStripe && step == 1 && $scope.currentStep == 1
        return true
      if $scope.user.account.hasConnectedStripe && step == 4 && $scope.currentStep == 4
        return true
      if step == $scope.currentStep
        return true

      return false

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
      $scope.currentStep += 1

      AccountServiceChannel.accountUpdated()

    $scope.getPlansClicked = () ->
      $scope.display_loading()

      $http.post('/dashboard/plans/get_stripe_plans').then(
        (response) ->
          $scope.dismiss_loading()
          $scope.form_submitted = false

          $scope.plans = response.data.plans
          $scope.currentStep += 1
        (http)  ->
          $scope.dismiss_loading()

      )

    $scope.selectPlan = (plan) ->
      $scope.plansToImport.push(plan)

    $scope.isPlanSelected = (plan) ->
        if $scope.plansToImport.indexOf(plan) > -1
          return true

        return false

    $scope.importPlansClicked = () ->
      if $scope.plansToImport.length == 0
        return false

      $scope.display_loading()

      plan_ids = []
      angular.forEach($scope.plansToImport, (plan,index) =>
        plan_ids.push(plan.id)
      )
      params = {
        plans: plan_ids
      }
      $http.post('/dashboard/plans/import_stripe_plans', params).then(
        (response) ->
          $scope.dismiss_loading()
          $scope.form_submitted = false

          message = "Your plans are importing!"
          $scope.display_success_message(message)

          $scope.dismissModal()
        (http)  ->
          $scope.dismiss_loading()

          message = http.statusText
          $scope.display_error_message(message)
      )

    init()
]

ConnectStripeController.$inject = ['$scope', 'Plan', '$window', 'Account', '$timeout', '$interval', 'fileReader', 'stripe', 'Upload', 'AccountServiceChannel', 'PlansServiceChannel', '$http']

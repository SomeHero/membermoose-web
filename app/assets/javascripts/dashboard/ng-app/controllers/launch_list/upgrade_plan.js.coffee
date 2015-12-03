@UpgradePlanController = angular.module('dashboardApp').controller 'UpgradePlanController', [
  '$scope'
  '$state'
  'Plan'
  '$window'
  'Account'
  '$timeout'
  'fileReader'
  'stripe'
  'Upload'
  'AccountServiceChannel'
  'PlansServiceChannel'
  '$http'
  ($scope, $state, Plan, window, Account, $timeout, fileReader, stripe, Upload, AccountServiceChannel, PlansServiceChannel, $http) ->
    init = () ->
      window.scope = $scope

      $scope.fromLaunch = $state.current.data.fromLaunch

      if !upgrade_plan_modal
        upgrade_plan_modal = $('[data-remodal-id=upgrade-plan-modal]').remodal($scope.options)

      upgrade_plan_modal.open();
      $scope.setCurrentModal(upgrade_plan_modal)

    $scope.upgradePlanSubmit = (form) ->
      stripe_key = $scope.getPublishableKey()

      stripe.setPublishableKey(stripe_key)
      $scope.form_submitted = true

      if form.$valid
        $scope.display_loading()

        stripe.card.createToken($scope.credit_card).then((token) ->
          console.log 'token created for card ending in ', token.card.last4
          params = {
            stripe_token: token
          }
          $http.post('/dashboard/account/' + $scope.user.id  + '/upgrade_plan', params).then(
            (response) ->
              $scope.setUser(response.data)

              $scope.dismiss_loading()
              $scope.form_submitted = false

              message = "Your successfully upgraded your plan. You're awesome."
              $scope.display_success_message(message)

              AccountServiceChannel.accountUpdated()

              if !$scope.fromLaunch
                $scope.dismissModal()

            (http)  ->
              $scope.dismiss_loading()

              message = http.statusText
              $scope.display_error_message(message)
          )
        ).catch (err) ->
          $scope.loading.show_spinner = false

          if err.type and /^Stripe/.test(err.type)
            console.log 'Stripe error: ', err.message
          else
            console.log 'Other error occurred, possibly with your API', err.message
          return
      else
        $scope.form_submitted = true

    init()
]

UpgradePlanController.$inject = ['$scope', '$state', 'Plan', '$window', 'Account', '$timeout', 'fileReader', 'stripe', 'Upload', 'AccountServiceChannel', 'PlansServiceChannel', '$http']

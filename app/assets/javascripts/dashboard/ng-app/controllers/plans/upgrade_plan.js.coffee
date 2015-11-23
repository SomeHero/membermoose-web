@UpgradePlanController = angular.module('dashboardApp').controller 'UpgradePlanController', [
  '$scope'
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
  ($scope, Plan, window, Account, $timeout, fileReader, stripe, Upload, AccountServiceChannel, PlansServiceChannel, $http) ->
    init = () ->
      window.scope = $scope

      if !upgrade_plan_modal
        upgrade_plan_modal = $('[data-remodal-id=upgrade-plan-modal]').remodal($scope.options)

      upgrade_plan_modal.open();
      $scope.setCurrentModal(upgrade_plan_modal)

    $scope.upgradePlanSubmit = () ->
      stripe_key = $scope.getPublishableKey()

      stripe.setPublishableKey(stripe_key)
      $scope.display_loading()
      $scope.form_submitted = true

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

          (http)  ->
            $scope.dismiss_loading()

            message = http.statusText
            $scope.display_error_message(message)
        )
      )

    init()
]

UpgradePlanController.$inject = ['$scope', 'Plan', '$window', 'Account', '$timeout', 'fileReader', 'stripe', 'Upload', 'AccountServiceChannel', 'PlansServiceChannel', '$http']

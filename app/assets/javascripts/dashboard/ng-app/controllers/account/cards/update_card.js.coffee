@UpdateCardController = angular.module('dashboardApp').controller 'UpdateCardController', [
  '$scope'
  '$stateParams'
  '$state'
  'Card'
  'stripe'
  '$http'
  '$window'
  ($scope, $stateParams, $state, Card, stripe, $http, window) ->
    init = () ->
      window.scope = $scope
      $scope.form_submitted = false
      if !$stateParams.card
        $state.go('dashboard.cards')

      $scope.card = $stateParams.card
      $scope.creditCard = {
        name: $scope.card.nameOnCard,
        exp_month: $scope.card.expirationMonth,
        exp_year: $scope.card.expirationYear
      }
      if !updateCardModal
        updateCardModal = $('[data-remodal-id=update-card-modal]').remodal($scope.options)

      $scope.setCurrentModal(updateCardModal)
      updateCardModal.open()

    $scope.updateCardSubmit = (form) ->
      if form.$valid
        stripeKey = $scope.getPublishableKey()
        stripe.setPublishableKey(stripeKey)

        $scope.display_loading()
        $scope.modalErrorMessage = null
        #$scope.form_submitted = true

        stripe.card.createToken($scope.creditCard).then((token) ->
          params = {
              stripe_token: token,
          }
          $http.put('/dashboard/account/' + $scope.user.account.id + '/cards/' + $scope.card.id, params).then(
            (response) ->
              newCard = new Card(response.data)

              angular.forEach($scope.user.account.cards, (value, index) =>
                if value.id == $scope.card.id
                  $scope.user.account.cards[index] = newCard

                  return
              )
              $scope.dismiss_loading()
              #$scope.form_submitted = false

              message = "Your card was successfully added. You're awesome."
              $scope.display_success_message(message)

              $scope.dismissModal()

            (http)  ->
              $scope.dismiss_loading()

              message = http.statusText
              $scope.display_error_message(message)
          )
        ).catch (err) ->
          $scope.dismiss_loading()

          $scope.display_error_message(err.message)
      else
        $scope.form_submitted = true

    init()
]

UpdateCardController.$inject = ['$scope', '$stateParams', '$state', 'Card', 'stripe', '$http', 'window']

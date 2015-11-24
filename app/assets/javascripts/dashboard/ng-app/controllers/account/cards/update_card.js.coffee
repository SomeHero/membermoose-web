@UpdateCardController = angular.module('dashboardApp').controller 'UpdateCardController', [
  '$scope'
  '$stateParams'
  '$state'
  'Card'
  'stripe'
  '$window'
  ($scope, $stateParams, $state, Card, stripe, window) ->
    init = () ->
      window.scope = $scope
      if !$stateParams.card
        $state.go('dashboard.cards')

      $scope.card = $stateParams.card

      if !updateCardModal
        updateCardModal = $('[data-remodal-id=update-card-modal]').remodal($scope.options)

      $scope.setCurrentModal(updateCardModal)
      updateCardModal.open()

    $scope.updateCardSubmit = (form) ->
      stripeKey = $scope.getPublishableKey()
      stripe.setPublishableKey(stripeKey)

      $scope.display_loading()
      $scope.modalErrorMessage = null
      #$scope.form_submitted = true

      stripe.card.createToken($scope.creditCard).then((token) ->
        new Card({
          id: $scope.card.id,
          card_brand: $scope.creditCard.card_brand,
          card_last4: $scope.creditCard.card_last4,
          exp_month: $scope.creditCard.exp_month,
          exp_year: $scope.creditCard.exp_year,
          stripe_token: token
        }).update().then(
          (response) ->
            newCard = new Card(response.data)

            angular.forEach($scope.user.account.cards, (value, index) =>
              if value.id == $scope.card.id
                $scope.user.account.cards[index] = newCard

                return
            )
            $scope.dismiss_loading()
            #$scope.form_submitted = false

            message = "Your credit card was successfully added. You're awesome."
            $scope.display_success_message(message)

            $scope.dismissModal()

          (http)  ->
            $scope.dismiss_loading()

            message = http.statusText
            $scope.display_error_message(message)
        )
      ).catch (err) ->
        $scope.dismiss_loading()

        $scope.modalErrorMessage = err.message

    init()
]

UpdateCardController.$inject = ['$scope', '$stateParams', '$state', 'Card', 'stripe', 'window']

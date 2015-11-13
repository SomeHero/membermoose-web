@CardsController = angular.module('dashboardApp').controller 'CardsController', [
  '$scope'
  '$stateParams'
  'Card'
  'stripe'
  '$window'
  ($scope, $stateParams, Card, stripe, window) ->
    window.scope = $scope
    updateCardModal = null
    deleteCardModal = null
    $scope.selectedCard = null
    $scope.creditCard = {}

    $scope.updateCardClicked = (card) ->
      $scope.selectedCard = card

      if !updateCardModal
        updateCardModal = $('[data-remodal-id=update-card-modal]').remodal($scope.options)

      $scope.setCurrentModal(updateCardModal)
      updateCardModal.open()

    $scope.updateCardSubmit = (form) ->
      stripeKey = $scope.getPublishableKey()
      stripe.setPublishableKey(stripeKey)

      $scope.displayLoading()
      #$scope.form_submitted = true

      stripe.card.createToken($scope.creditCard).then((token) ->
        new Card({
          id: $scope.selectedCard.id,
          card_brand: $scope.creditCard.card_brand,
          card_last4: $scope.creditCard.card_last4,
          exp_month: $scope.creditCard.exp_month,
          exp_year: $scope.creditCard.exp_year,
          stripe_token: token
        }).update().then(
          (response) ->
            newCard = new Card(response.data)

            angular.forEach($scope.account.cards, (value, index) =>
              if value.id == $scope.selectedCard.id
                $scope.account.cards[index] = newCard

                return
            )
            $scope.creditCard = {}

            $scope.dismissLoading()
            #$scope.form_submitted = false

            message = "Your credit card was successfully added. You're awesome."
            $scope.displaySuccessMessage(message)

            $scope.dismissModal()

          (http)  ->
            $scope.dismissLoading()

            message = http.statusText
            $scope.displayErrorMessage(message)
        )
      )

    $scope.deleteCardClicked = (card) ->
      $scope.selectedCard = card

      if !deleteCardModal
        deleteCardModal = $('[data-remodal-id=delete-card-modal]').remodal($scope.options)

      $scope.setCurrentModal(deleteCardModal)
      deleteCardModal.open()

    $scope.deleteCardSubmit = (card) ->
      $scope.displayLoading()

      Card.setUrl('/bulls/cards')
      card = new Card($scope.selectedCard)
      card.delete().then(
        (response) ->
          $scope.dismissLoading()

          message = "Your card, " + $scope.selectedCard.last4 + ", was successfully deleted."
          $scope.displaySuccessMessage(message)

          angular.forEach($scope.account.cards, (value,index) =>
            if value.id == $scope.selectedCard.id
              $scope.account.cards.splice(index, 1)
          )
          $scope.selectedCard = null

          $scope.dismissModal()
        (http)  ->
          $scope.dismissLoading()

          errors = http.data

          message = errors
          $scope.displayErrorMessage(message)
      )
]
CardsController.$inject = ['$scope', '$stateParams', 'window']

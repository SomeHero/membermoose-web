@MemberUpdateCardController = angular.module('dashboardApp').controller 'MemberUpdateCardController', [
  '$scope'
  '$stateParams'
  '$state'
  'Card'
  'stripe'
  '$window'
  ($scope, $stateParams, $state, Card, stripe, window) ->
    init = () ->
      window.scope = $scope
      $scope.currentStep = 1
      $scope.selectedCards = []
      $scope.form_submitted = false
      if !$stateParams.member
        $state.go('dashboard.members')

        return

      $scope.member = $stateParams.member

      if !updateCardModal
        updateCardModal = $('[data-remodal-id=update-card-modal]').remodal($scope.options)

      $scope.setCurrentModal(updateCardModal)
      updateCardModal.open()

    $scope.selectCard = (card) ->
      $scope.selectedCards = []

      $scope.selectedCards.push(card)

    $scope.isSelected = (card) ->
      if $scope.selectedCards.indexOf(card) > -1
        return true

      return false

    $scope.nextStepClicked = () ->
      card = $scope.selectedCards[0]

      $scope.creditCard = {
        name: card.nameOnCard,
        exp_month: card.expirationMonth,
        exp_year: card.expirationYear
      }
      $scope.currentStep += 1

    $scope.previousStepClicked = () ->
      $scope.currentStep -= 1

    $scope.updateCardSubmit = (form) ->
      if form.$valid
        $scope.setStripePublishableKey($scope.user.account.paymentProcessors)

        $scope.display_loading()
        $scope.modalErrorMessage = null
        card = $scope.selectedCards[0]

        stripe.card.createToken($scope.creditCard).then((token) ->
          new Card({
            id: card.id,
            card_brand: card.card_brand,
            card_last4: card.card_last4,
            exp_month: card.exp_month,
            exp_year: card.exp_year,
            stripe_token: token
          }).update().then(
            (response) ->
              newCard = new Card(response.data)

              angular.forEach($scope.member.cards, (value, index) =>
                if value.id == card.id
                  $scope.member.cards[index] = newCard

                  return
              )
              $scope.dismiss_loading()

              message = "The credit card was successfully updated."
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

MemberUpdateCardController.$inject = ['$scope', '$stateParams', '$state', 'Card', 'stripe', 'window']

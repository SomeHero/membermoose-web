@MemberDeleteCardController = angular.module('dashboardApp').controller 'MemberDeleteCardController', [
  '$scope'
  '$state'
  '$stateParams'
  'Card'
  'stripe'
  '$window'
  ($scope, $state, $stateParams, Card, stripe, window) ->
    init = () ->
      window.scope = $scope
      $scope.currentStep = 1

      if !$stateParams.member
        $state.go('dashboard.members')

        return

      $scope.member = $stateParams.member
      $scope.selectedCard = null

      if !deleteCardModal
        deleteCardModal = $('[data-remodal-id=delete-card-modal]').remodal($scope.options)

      $scope.setCurrentModal(deleteCardModal)
      deleteCardModal.open()

    $scope.selectCard = (card) ->
      $scope.selectedCards = []

      $scope.selectedCards.push(card)

    $scope.isSelected = (card) ->
      if $scope.selectedCards.indexOf(card) > -1
        return true

      return false

    $scope.nextStepClicked = () ->
      $scope.selectedCard = $scope.selectedCards[0]

      $scope.currentStep += 1

    $scope.previousStepClicked = () ->
      $scope.currentStep -= 1

    $scope.deleteCardSubmit = () ->
      $scope.display_loading()

      Card.setUrl('/dashboard/cards')
      new Card($scope.selectedCard).delete().then(
        (response) ->
          $scope.dismiss_loading()

          angular.forEach($scope.member.cards, (value, index) =>
            if value.id == $scope.selectedCard.id
              $scope.member.cards.splice(index, 1)
              return
          )

          message = "Your card, " + $scope.selectedCard.last4 + ", was successfully deleted."
          $scope.display_success_message(message)

          $scope.dismissModal()
        (http)  ->
          $scope.dismiss_loading()

          errors = http.data

          $scope.display_success_message(errors)
      )

    init()
]

MemberDeleteCardController.$inject = ['$scope', '$state', '$stateParams', 'Card', 'stripe', 'window']

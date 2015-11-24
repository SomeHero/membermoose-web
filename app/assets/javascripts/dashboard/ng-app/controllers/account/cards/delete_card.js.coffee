@DeleteCardController = angular.module('dashboardApp').controller 'DeleteCardController', [
  '$scope'
  '$stateParams'
  'Card'
  'stripe'
  '$window'
  ($scope, $stateParams, Card, stripe, window) ->
    init = () ->
      window.scope = $scope
      if !$stateParams.card
        $state.go('dashboard.cards')

      $scope.card = $stateParams.card

      if !deleteCardModal
        deleteCardModal = $('[data-remodal-id=delete-card-modal]').remodal($scope.options)

      $scope.setCurrentModal(deleteCardModal)
      deleteCardModal.open()

    $scope.deleteCardSubmit = () ->
      $scope.display_loading()

      Card.setUrl('/dashboard/cards')
      new Card($scope.card).delete().then(
        (response) ->
          $scope.dismiss_loading()

          message = "Your card, " + $scope.selectedCard.last4 + ", was successfully deleted."
          $scope.displaySuccessMessage(message)

          angular.forEach($scope.account.cards, (value,index) =>
            if value.id == $scope.selectedCard.id
              $scope.account.cards.splice(index, 1)
          )
          $scope.selectedCard = null

          $scope.dismissModal()
        (http)  ->
          $scope.dismiss_loading()

          errors = http.data

          $scope.modalErrorMessage = errors
      )

    init()
]

DeleteCardController.$inject = ['$scope', '$stateParams', 'Card', 'stripe', 'window']

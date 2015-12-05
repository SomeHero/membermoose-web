@DeleteCardController = angular.module('dashboardApp').controller 'DeleteCardController', [
  '$scope'
  '$stateParams'
  'Card'
  'stripe'
  '$http'
  '$window'
  ($scope, $stateParams, Card, stripe, $http, window) ->
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

      $http.delete('/dashboard/account/' + $scope.user.account.id + '/cards/' + $scope.card.id).then(
        (response) ->
          $scope.dismiss_loading()

          message = "Your card, ending in " + $scope.card.last4 + ", was successfully deleted."
          $scope.display_success_message(message)

          angular.forEach($scope.user.account.cards, (value, index) =>
            if value.id == $scope.card.id
              $scope.user.account.cards.splice(index)

              return
          )
          $scope.dismissModal()
        (http)  ->
          $scope.dismiss_loading()

          errors = http.data

          $scope.display_error_message(errors)
      )

    init()
]

DeleteCardController.$inject = ['$scope', '$stateParams', 'Card', 'stripe', 'window']

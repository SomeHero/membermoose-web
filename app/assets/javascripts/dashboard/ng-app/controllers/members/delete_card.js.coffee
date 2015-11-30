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
      if !$stateParams.member
        $state.go('dashboard.members')

        return

      $scope.member = $stateParams.member

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

          message = "Your card, " + $scope.card.last4 + ", was successfully deleted."
          $scope.display_success_message(message)

          $scope.dismissModal()
        (http)  ->
          $scope.dismiss_loading()

          errors = http.data

          $scope.modalErrorMessage = errors
      )

    init()
]

MemberDeleteCardController.$inject = ['$scope', '$state', '$stateParams', 'Card', 'stripe', 'window']

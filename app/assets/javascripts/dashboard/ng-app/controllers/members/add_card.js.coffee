@MemberAddCardController = angular.module('dashboardApp').controller 'MemberAddCardController', [
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
      if !$stateParams.member
        $state.go('dashboard.members')

        return

      $scope.member = $stateParams.member

      if !modal
        modal = $('[data-remodal-id=add-card-modal]').remodal($scope.options)

      $scope.setCurrentModal(modal)
      modal.open()

    $scope.addCardSubmit = (form) ->
      if form.$valid
        $scope.setStripePublishableKey($scope.user.account.paymentProcessors)

        $scope.display_loading()

        stripe.card.createToken($scope.credit_card).then((token) ->
          params = {
              stripe_token: token,
              member_id: $scope.member.id,
          }
          $http.post('/dashboard/cards/', params).then(
            (response) ->
              newCard = new Card(response.data)

              $scope.member.cards.push(newCard)

              $scope.dismiss_loading()

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

          $scope.display_error_message(err.message)
      else
        $scope.form_submitted = true

    init()
]

MemberAddCardController.$inject = ['$scope', '$stateParams', '$state', 'Card', 'stripe', '$http', 'window']

@CardsController = angular.module('dashboardApp').controller 'CardsController', [
  '$scope'
  '$state'
  '$stateParams'
  'Card'
  'stripe'
  '$window'
  ($scope, $state, $stateParams, Card, stripe, window) ->
    init = () ->
      window.scope = $scope

      $(document).on 'closed', '.remodal', (e) ->
        # Reason: 'confirmation', 'cancellation'
        if $state.current.name.indexOf("cards") > -1
          $state.go('dashboard.cards')


      $scope.init()

    init()
]
CardsController.$inject = ['$scope', '$state', '$stateParams', 'window']

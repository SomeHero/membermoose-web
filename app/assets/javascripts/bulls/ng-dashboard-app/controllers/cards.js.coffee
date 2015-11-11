@CardsController = angular.module('dashboardApp').controller 'CardsController', [
  '$scope'
  '$stateParams'
  'Subscription'
  '$window'
  ($scope, $stateParams, Subscription, window) ->
    window.scope = $scope

]
CardsController.$inject = ['$scope', '$stateParams', 'window']

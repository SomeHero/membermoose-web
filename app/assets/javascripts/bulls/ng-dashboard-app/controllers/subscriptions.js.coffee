@SubscriptionsController = angular.module('dashboardApp').controller 'SubscriptionsController', [
  '$scope'
  '$stateParams'
  '$window'
  ($scope, $stateParams, window) ->
    window.scope = $scope

    $scope.account = account
]
SubscriptionsController.$inject = ['$scope', '$stateParams', 'window']

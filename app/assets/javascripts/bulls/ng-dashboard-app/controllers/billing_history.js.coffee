@BillingHistoryController = angular.module('dashboardApp').controller 'BillingHistoryController', [
  '$scope'
  '$stateParams'
  '$window'
  ($scope, $stateParams, window) ->
    window.scope = $scope

    $scope.bull = bull
    $scope.account = account
]
BillingHistoryController.$inject = ['$scope', '$stateParams', 'window']

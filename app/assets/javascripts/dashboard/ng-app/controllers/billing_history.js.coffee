@BillingHistoryController = angular.module('dashboardApp').controller 'BillingHistoryController', [
  '$scope'
  '$stateParams'
  '$window'
  ($scope, $stateParams, window) ->
    window.scope = $scope

    $scope.init()
]
BillingHistoryController.$inject = ['$scope', '$stateParams', 'window']

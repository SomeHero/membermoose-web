@DashboardController = angular.module('dashboardApp').controller 'DashboardController', [
  '$scope'
  '$stateParams'
  '$window'
  ($scope, $stateParams, window) ->
    window.scope = $scope

    $scope.options = {
      "hashTracking": false,
      "closeOnOutsideClick": false
    }
    $scope.bull = bull
    $scope.account = account
]
DashboardController.$inject = ['$scope', '$stateParams', 'window']

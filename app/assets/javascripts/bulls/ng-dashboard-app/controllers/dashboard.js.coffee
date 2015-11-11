@DashboardController = angular.module('dashboardApp').controller 'DashboardController', [
  '$scope'
  '$stateParams'
  '$window'
  ($scope, $stateParams, window) ->
    window.scope = $scope

    $scope.account = account
]
DashboardController.$inject = ['$scope', '$stateParams', 'window']

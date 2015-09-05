@DashboardController = angular.module('dashboardApp').controller 'DashboardController', [
  '$scope'
  '$window'
  ($scope, window) ->
    $scope.setMenuItemSelected = (url) ->
      if url == window.location.pathname
        return "selected"

    return
]

AccountController.$inject = ['$scope', 'window']

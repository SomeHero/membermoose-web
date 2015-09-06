@DashboardController = angular.module('dashboardApp').controller 'DashboardController', [
  '$scope',
  'Account',
  '$window'
  ($scope, Account, window) ->
    $scope.user = null

    Account.get(1).then (user) ->
      console.log "get account"
      $scope.user = user

    $scope.setMenuItemSelected = (url) ->
      if url == window.location.pathname
        return "selected"

    return
]

AccountController.$inject = ['$scope', 'Account', 'window']

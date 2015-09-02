@AccountController = angular.module('dashboardApp').controller 'AccountController', [
  '$scope'
  'Account'
  '$window'
  ($scope, Account, window) ->
    Account.get(1).then (user) ->
      console.log "get account"
      $scope.user = user

    $scope.updateUser = (user) ->
      console.log "updating user"

      $scope.user.update()

    return
]

AccountController.$inject = ['$scope', 'Account', 'window']

@AccountController = angular.module('dashboardApp').controller 'AccountController', [
  '$scope'
  'Account'
  '$window'
  ($scope, Account, window) ->
    $scope.user = null

    Account.get(1).then (user) ->
      console.log "get account"
      $scope.user = user

    $scope.showEditBar = () ->
      return $scope.user != null

    $scope.updateUser = (user) ->
      console.log "updating user"

      $scope.user.update()

    return
]

AccountController.$inject = ['$scope', 'Account', 'window']

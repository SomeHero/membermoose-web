@AccountController = angular.module('dashboardApp').controller 'AccountController', [
  '$scope'
  'Account'
  '$stateParams'
  '$window'
  ($scope, Account, $stateParams, window) ->

    $scope.getAccount = () ->
      Account.get($stateParams.id).then (result) ->
        $scope.user = result.data

    $scope.updateAccount = (user, form) ->
      console.log "updating user"

      if form.$valid
        user.update().then(
          (updated_user) ->
            $scope.$parent.success_message = "Your account was successfully updated."
            $scope.$parent.show_success_message = true

            console.log("account updated")
          (http)  ->
            console.log("error updating account")
            errors = http.data

            $scope.$parent.error_message = "Sorry, an unexpected error ocurred.  Please try again."
            $scope.$parent.show_error_message = true
        )

    $scope.getAccount()

    return
]

AccountController.$inject = ['$scope', 'Account', '$stateParams', 'window']

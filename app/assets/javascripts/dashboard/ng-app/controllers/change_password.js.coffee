@ChangePasswordController = angular.module('dashboardApp').controller 'ChangePasswordController', [
  '$scope'
  '$stateParams'
  '$http'
  '$window'
  '$timeout'
  'AccountServiceChannel'
  ($scope, $stateParams, $http, window, $timeout, AccountServiceChannel) ->

    init = () ->
      $scope.init()

      $scope.change_password = {}

    $scope.changePasswordSubmit = (form) ->
      if form.$valid
        $scope.display_loading()

        params = {
          current_password: $scope.change_password.current_password,
          new_password: $scope.change_password.new_password,
          new_password_again: $scope.change_password.new_password_again
        }
        $http.post('/dashboard/account/' + $scope.user.id  + '/change_password', params).then(
          () ->
            $scope.dismiss_loading()
            $scope.form_submitted = false

            message = "You successfully updated your password."
            $scope.display_success_message(message)

            $scope.change_password = {}
          (http)  ->
            $scope.dismiss_loading()

            message = http.statusText
            $scope.display_error_message(message)
        )

    init()
]

ChangePasswordController.$inject = ['$scope', '$stateParams', '$http', 'window', '$timeout', 'AccountServiceChannel']

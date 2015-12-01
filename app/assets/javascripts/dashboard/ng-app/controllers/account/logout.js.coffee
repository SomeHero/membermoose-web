@LogoutCofirmationController = angular.module('dashboardApp').controller 'LogoutConfirmationController', [
  '$scope'
  '$rootScope'
  '$state'
  '$stateParams'
  '$window'
  '$timeout'
  'Auth'
  ($scope, $rootScope, $state, $stateParams, $window, $timeout, Auth) ->

    init = () ->
      window.scope = $scope

      if !modal
        modal = $('[data-remodal-id=logout-modal]').remodal($scope.options)

      $scope.setCurrentModal(modal)
      modal.open()

    $scope.dismissClicked = () ->
      $scope.dismissModal()
      
      $state.go($rootScope.previousState)

    $scope.logoutClicked = () ->
      $scope.display_loading()
      config = headers: 'X-HTTP-Method-Override': 'DELETE'

      Auth.logout(config).then ((oldUser) ->
        $window.location.href = "/users/sign_in"
      ), (error) ->
        return

    init()
]

DeletePlanController.$inject = ['$scope', 'rootScope', '$state', '$stateParams', 'Plan', '$modal', '$http', 'window', '$timeout', 'PlansServiceChannel']

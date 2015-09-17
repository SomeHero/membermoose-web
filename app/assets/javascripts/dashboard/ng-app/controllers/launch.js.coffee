@LaunchController = angular.module('dashboardApp').controller 'LaunchController', [
  '$scope',
  'Account',
  'Plan',
  '$window',
  '$modal'
  ($scope, Account, Plan, window, $modal) ->
    if window.location.pathname == "/dashboard/launch"
      modalInstance = $modal.open(
        animation: true
        templateUrl: 'dashboard/ng-app/templates/launchlist/launch_list.html'
        controller: 'LaunchListController'
        size: 'lg'
        resolve:
          user: ->
            $scope.user
      )

    return
]

LaunchController.$inject = ['$scope', 'Account', 'Plan', 'window', '$modal']

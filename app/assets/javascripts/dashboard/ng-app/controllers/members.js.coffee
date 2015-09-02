angular.module('dashboardApp').controller 'MembersController', [
  '$scope'
  'Member'
  '$window'
  ($scope, Member, window) ->
    Member.get().then (members) ->
      $scope.members = members

      return
]

@MembersController = angular.module('dashboardApp').controller 'MembersController', [
  '$scope'
  'Member'
  '$window'
  ($scope, Member, window) ->
    $scope.member = null
    $scope.members = []

    Member.get().then (members) ->
      $scope.members = members

    $scope.selectMember = (event, member) ->
      if $scope.member == member
        $scope.member = null
      else
        $scope.member = member

    $scope.showEditBar = () ->
      return $scope.member != null

    $scope.closeEditBar = () ->
      $scope.member = null

    return
]

MembersController.$inject = ['$scope', 'Member', 'window']

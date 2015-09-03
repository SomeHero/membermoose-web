@MembersController = angular.module('dashboardApp').controller 'MembersController', [
  '$scope'
  'Member'
  '$window'
  ($scope, Member, window) ->
    $scope.member = null

    Member.get().then (members) ->
      $scope.members = members

    $scope.selectMember = (event, member) ->
      $scope.member = member

    $scope.showEditBar = () ->
      return $scope.member != null

    $scope.closeEditBar = () ->
      $scope.member = null

    return
]

MembersController.$inject = ['$scope', 'Member', 'window']

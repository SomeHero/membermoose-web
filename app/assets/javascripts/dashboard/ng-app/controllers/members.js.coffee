@MembersController = angular.module('dashboardApp').controller 'MembersController', [
  '$scope'
  'Member'
  '$window'
  ($scope, Member, window) ->
    window.scope = $scope
    $scope.members = []
    $scope.selected_member = null
    $scope.totalItems = 0
    $scope.currentPage = 1
    $scope.itemsPerPage = 10
    $scope.isLoading = true

    $scope.edit_panel_open = false
    $scope.setPage = (pageNo) ->
      $scope.currentPage = pageNo

    $scope.pageChanged = () ->
      console.log('Page changed to: ' + $scope.currentPage);
      $scope.isLoading = true
      $scope.getMembers()

    $scope.getMembers = () ->
      Member.setUrl('/dashboard/members?page={{page}}')
      Member.get({page: $scope.currentPage}).then (result) ->
        console.log("get members")
        $scope.members = result.data
        $scope.totalItems = result.originalData.total_items
        $scope.isLoading = false

    $scope.selectMember = (event, member) ->
      if $scope.selected_member == member
        $scope.edit_panel_open = false
        $scope.selected_member = null
      else
        $scope.edit_panel_open = true
        $scope.selected_member = member

      $scope.$parent.show_success_message = false
      $scope.$parent.show_error_message = false

    $scope.updateMember = (member, form) ->
      if form.$valid
        Member.setUrl('/dashboard/members')
        member.update().then(
          (updated_member) ->
            angular.forEach($scope.members, (value,index) =>
              if value.id == updated_member.id
                $scope.members[index] = updated_member
            )
            $scope.closeEditBar()

            $scope.$parent.success_message = "Member, " + member.firstName + " " + member.lastName + ", was successfully updated."
            $scope.$parent.show_success_message = true

            console.log("member updated")
          (http)  ->
            console.log("error updating member")
            errors = http.data

            $scope.$parent.error_message = "Sorry, an unexpected error ocurred.  Please try again."
            $scope.$parent.show_error_message = true
        )

    $scope.showEditBar = () ->
      $scope.edit_panel_open = true

    $scope.closeEditBar = () ->
      $scope.edit_panel_open = false

    $scope.getMembers()

    return
]

MembersController.$inject = ['$scope', 'Member', 'window']

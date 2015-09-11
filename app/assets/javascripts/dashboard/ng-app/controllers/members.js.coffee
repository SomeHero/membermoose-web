@MembersController = angular.module('dashboardApp').controller 'MembersController', [
  '$scope'
  'Member'
  '$window'
  ($scope, Member, window) ->
    $scope.member = null
    $scope.members = []

    $scope.edit_panel_open = false

    $scope.billing_history =  [
      {payment_date:'8/1/2015', amount: 100, status: 'Paid'},
      {payment_date:'7/1/2015', amount: 100, status: 'Paid'},
      {payment_date:'6/1/2015', amount: 100, status: 'Paid'},
      {payment_date:'5/1/2015', amount: 100, status: 'Paid'},
      {payment_date:'4/1/2015', amount: 100, status: 'Paid'},
      {payment_date:'3/1/2015', amount: 100, status: 'Paid'},
    ];
    Member.get().then (members) ->
      $scope.members = members

    $scope.selectMember = (event, member) ->
      $scope.edit_panel_open = true
      $scope.member = angular.copy(member)

      $scope.$parent.show_success_message = false
      $scope.$parent.show_error_message = false
      
    $scope.updateMember = (member, form) ->
      if form.$valid
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

    return
]

MembersController.$inject = ['$scope', 'Member', 'window']

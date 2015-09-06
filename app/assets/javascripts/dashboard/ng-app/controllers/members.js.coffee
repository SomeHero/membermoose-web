@MembersController = angular.module('dashboardApp').controller 'MembersController', [
  '$scope'
  'Member'
  '$window'
  ($scope, Member, window) ->
    $scope.member = null
    $scope.members = []

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

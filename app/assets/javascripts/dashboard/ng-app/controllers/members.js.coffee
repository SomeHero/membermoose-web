@MembersController = angular.module('dashboardApp').controller 'MembersController', [
  '$scope'
  'Member'
  '$window'
  '$timeout'
  ($scope, Member, window, $timeout) ->
    window.scope = $scope
    $scope.members = []
    $scope.selected_member = null
    $scope.totalItems = 0
    $scope.searchItems = 0
    $scope.currentPage = 1
    $scope.itemsPerPage = 10
    $scope.isLoading = true
    $scope.display_search = false
    $scope.statuses = [
        {text: 'Active', value: '0'},
        {text: 'InActive', value: '1'},
    ]
    $scope.edit_panel_open = false
    options = {
      "hashTracking": false,
      "closeOnOutsideClick": false
    }
    billing_history_modal = null
    next_invoice_modal = false

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
        $scope.searchItems = $scope.totalItems
        $scope.isLoading = false

    $scope.getSearchCount = () ->
      Member.setUrl('/dashboard/members/count')
      Member.query({
          firstName: $scope.search.first_name,
          lastName: $scope.search.last_name,
          email_address: $scope.search.email_address,
          plan_id: $scope.search.plan_id,
          status: $scope.search.status
      }).then (result) ->
        $scope.searchItems = result.data.count

    $scope.search = () ->
      Member.setUrl('/dashboard/members')
      Member.query({
          firstName: $scope.search.first_name,
          lastName: $scope.search.last_name,
          email_address: $scope.search.email_address,
          plan_id: $scope.search.plan_id,
          status: $scope.search.status
      }).then (result) ->
        $scope.members = result.data
        $scope.totalItems = result.originalData.total_items

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
      Member.setUrl('/dashboard/members')
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
            $scope.clear_message()

            console.log("member updated")
          (http)  ->
            console.log("error updating member")
            errors = http.data

            $scope.$parent.error_message = "Sorry, an unexpected error ocurred.  Please try again."
            $scope.$parent.show_error_message = true
            $scope.clear_message()
        )

    $scope.billing_history_clicked = () ->
      if !billing_history_modal
        billing_history_modal = $('[data-remodal-id=billing-history-modal]').remodal(options)

      billing_history_modal.open();

    $scope.next_invoice_clicked = () ->
      if !next_invoice_modal
        next_invoice_modal = $('[data-remodal-id=next-invoice-modal]').remodal(options)

      next_invoice_modal.open()

    $scope.showEditBar = () ->
      $scope.edit_panel_open = true

    $scope.closeEditBar = () ->
      $scope.edit_panel_open = false

    $scope.clear_messages = () ->
      $timeout(remove_messages, 4000);

    $scope.toggle_search = () ->
      if $scope.display_search
        $scope.display_search = false
      else
        $scope.display_search = true

    remove_messages = () ->
      $scope.$parent.show_success_message = false

    $scope.getMembers()

    return
]

MembersController.$inject = ['$scope', 'Member', 'window', '$timeout']

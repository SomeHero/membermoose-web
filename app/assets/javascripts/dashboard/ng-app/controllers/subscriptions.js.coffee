@SubscriptionsController = angular.module('dashboardApp').controller 'SubscriptionsController', [
  '$scope'
  'Subscription'
  '$window'
  '$timeout'
  ($scope, Subscription, window, $timeout) ->
    window.scope = $scope
    $scope.selected_subscription = null
    $scope.subscriptions = []
    $scope.totalItems = 0
    $scope.searchItems = 0
    $scope.currentPage = 1
    $scope.itemsPerPage = 10
    $scope.isLoading = true
    $scope.display_search = false

    $scope.pageChanged = () ->
      console.log('Page changed to: ' + $scope.currentPage);
      $scope.isLoading = true
      $scope.getSubscriptions()

    $scope.getSubscriptions = () ->
      Subscription.setUrl('/dashboard/subscriptions?page={{page}}')
      Subscription.get({page: $scope.currentPage}).then (result) ->
        $scope.subscriptions = result.data
        $scope.totalItems = result.originalData.total_items
        $scope.searchItems = $scope.totalItems
        $scope.isLoading = false

    $scope.search = () ->
      Subscription.setUrl('/dashboard/subscriptions')
      Subscription.query({
          firstName: $scope.search.first_name,
          lastName: $scope.search.last_name,
          plan_id: $scope.search.plan_id
      }).then (result) ->
        $scope.subscriptions = result.data
        $scope.totalItems = result.originalData.total_items
        $scope.searchItems = $scope.totalItems
        $scope.isLoading = false

    $scope.getSearchCount = () ->
      Subscription.setUrl('/dashboard/subscriptions/count')
      Subscription.query({
          firstName: $scope.search.first_name,
          lastName: $scope.search.last_name,
          plan_id: $scope.search.plan_id
      }).then (result) ->
        $scope.searchItems = result.data.count

    $scope.selectSubscription = (event, subscription) ->
      if $scope.selected_subscription == subscription
        $scope.selected_subscription = null
      else
        $scope.selected_subscription = subscription

    $scope.showEditBar = () ->
      return $scope.selected_subscription != null

    $scope.closeEditBar = () ->
      $scope.subscription = null

    $scope.clear_messages = () ->
      $timeout(remove_messages, 4000);

    $scope.toggle_search = () ->
      if $scope.display_search
        $scope.display_search = false
      else
        $scope.display_search = true

    remove_messages = () ->
      $scope.$parent.show_success_message = false

    $scope.getSubscriptions()

    return
]

SubscriptionsController.$inject = ['$scope', 'Subscription', 'window', '$timeout']

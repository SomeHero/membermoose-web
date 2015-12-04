@SubscriptionsController = angular.module('dashboardApp').controller 'SubscriptionsController', [
  '$scope'
  '$state'
  'Subscription'
  'Plan'
  '$window'
  '$timeout'
  '$http'
  ($scope, $state, Subscription, Plan, window, $timeout, $http) ->
    init = () ->
      window.scope = $scope
      $scope.selected_subscription = null
      $scope.subscriptions = []
      $scope.plans = []
      $scope.selected_plan = null
      $scope.totalItems = 0
      $scope.searchItems = 0
      $scope.currentPage = 1
      $scope.itemsPerPage = 10
      $scope.isLoading = true
      $scope.display_search = false
      $scope.statuses = [
          {text: 'Subscribed', value: '0'},
          {text: 'Cancelled', value: '1'},
      ]
      $scope.search = {
        invoice_from_date: null,
        invoice_to_date: null
      }

      $(document).on 'closed', '.remodal', (e) ->
        # Reason: 'confirmation', 'cancellation'
        if $state.current.name.indexOf("subscriptions") > -1
          $state.go('dashboard.subscriptions')

      $scope.getSubscriptions()
      $scope.getPlans()
      $scope.init()

    $scope.pageChanged = () ->
      $scope.isLoading = true
      $scope.getSubscriptions()

    $scope.getPlans = () ->
      Plan.setUrl('/dashboard/plans?page={{page}}')
      Plan.get({page: $scope.currentPage}).then (result) ->
        $scope.plans = result.data
        $scope.totalItems = result.originalData.total_items
        $scope.isLoading = false

        #sortPlans()
      , (error) ->
        $scope.isLoading = false

    $scope.getSubscriptions = () ->
      Subscription.setUrl('/dashboard/subscriptions?page={{page}}')
      Subscription.get({page: $scope.currentPage}).then (result) ->
        $scope.subscriptions = result.data
        $scope.totalItems = result.originalData.total_items
        $scope.searchItems = $scope.totalItems
        $scope.isLoading = false
      , (error) ->
        $scope.isLoading = false

        errors = http.data

        message = "Sorry an error occurred. #{errors.message}"
        $scope.display_error_message(message)

    $scope.searchClicked = () ->
      Subscription.setUrl('/dashboard/subscriptions')
      Subscription.query({
          firstName: $scope.search.first_name,
          lastName: $scope.search.last_name,
          plan_id: $scope.search.plan_id,
          status: $scope.search.status
      }).then (result) ->
        $scope.subscriptions = result.data
        $scope.totalItems = result.originalData.total_items
        $scope.searchItems = $scope.totalItems
        $scope.isLoading = false
      , (error) ->
        $scope.isLoading = false

        errors = http.data

        message = "Sorry an error occurred. #{errors.message}"
        $scope.display_error_message(message)

    $scope.getSearchCount = () ->
      Subscription.setUrl('/dashboard/subscriptions/count')
      Subscription.query({
          firstName: $scope.search.first_name,
          lastName: $scope.search.last_name,
          plan_id: $scope.search.plan_id,
          status: $scope.search.status
      }).then (result) ->
        $scope.searchItems = result.data.count
      , (error) ->
        $scope.isLoading = false

        errors = http.data

        message = "Sorry an error occurred. #{errors.message}"
        $scope.display_error_message(message)

    $scope.selectSubscription = (event, subscription) ->
      if $scope.selected_subscription == subscription
        $scope.selected_subscription = null
      else
        $scope.selected_subscription = subscription

    $scope.showEditBar = () ->
      return $scope.selected_subscription != null

    $scope.closeEditBar = () ->
      $scope.selected_subscription = null

    $scope.toggle_search = () ->
      if $scope.display_search
        $scope.display_search = false
      else
        $scope.display_search = true

    init()
]

SubscriptionsController.$inject = ['$scope', '$state', 'Subscription', 'Plan', 'window', '$timeout', '$http']

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
    $scope.loading = {
      show_spinner: false
    }
    $scope.display_search = false
    $scope.statuses = [
        {text: 'Subscribed', value: '0'},
        {text: 'Cancelled', value: '1'},
    ]
    $scope.search = {
      invoice_from_date: null,
      invoice_to_date: null
    }
    options = {
      "hashTracking": false,
      "closeOnOutsideClick": false
    }

    change_plan_modal = null
    cancel_subscription_modal = null
    credit_subscription_modal = null

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
          plan_id: $scope.search.plan_id,
          status: $scope.search.status
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
          plan_id: $scope.search.plan_id,
          status: $scope.search.status
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
      $scope.selected_subscription = null

    $scope.toggle_search = () ->
      if $scope.display_search
        $scope.display_search = false
      else
        $scope.display_search = true

    $scope.cancel_subscription_clicked = () ->
      if !cancel_subscription_modal
        cancel_subscription_modal = $('[data-remodal-id=cancel-subscription-modal]').remodal(options)

      cancel_subscription_modal.open()

    $scope.cancel_subscription_submit = () ->
      Subscription.setUrl('/dashboard/subscriptions')
      $scope.loading.show_spinner = true
      $scope.selected_subscription.delete().then(
        () ->
          $scope.closeEditBar()

          $scope.$parent.success_message = "The subscription was successfully deleted."
          $scope.$parent.show_success_message = true
          $scope.clear_messages()

          $scope.loading.show_spinner = false
          cancel_subscription_modal.close()

          $scope.selected_subscription.status = "Cancelled"
          $scope.closeEditBar()

          console.log("subscription deleted")
        (http)  ->
          console.log("error deleting subscription")
          errors = http.data

          $scope.$parent.error_message = "Sorry, an unexpected error ocurred.  Please try again."
          $scope.$parent.show_error_message = true
          $scope.clear_messages()

          $scope.loading.show_spinner = false
      )

    $scope.change_plan_clicked = () ->
      if !change_plan_modal
        change_plan_modal = $('[data-remodal-id=change-plan-modal]').remodal(options)

      change_plan_modal.open()

    $scope.change_plan_submit = () ->
      console.log "subscription changed"

    $scope.getSubscriptions()

    return
]

SubscriptionsController.$inject = ['$scope', 'Subscription', 'window', '$timeout']

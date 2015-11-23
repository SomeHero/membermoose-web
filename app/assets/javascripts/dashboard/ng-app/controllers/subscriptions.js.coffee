@SubscriptionsController = angular.module('dashboardApp').controller 'SubscriptionsController', [
  '$scope'
  'Subscription'
  'Plan'
  '$window'
  '$timeout'
  '$http'
  ($scope, Subscription, Plan, window, $timeout, $http) ->
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

      change_plan_modal = null
      cancel_subscription_modal = null
      credit_subscription_modal = null

      $scope.getSubscriptions()
      $scope.getPlans()
      $scope.init()
      
    $scope.pageChanged = () ->
      console.log('Page changed to: ' + $scope.currentPage);
      $scope.isLoading = true
      $scope.getSubscriptions()

    $scope.getPlans = () ->
      Plan.setUrl('/dashboard/plans?page={{page}}')
      Plan.get({page: $scope.currentPage}).then (result) ->
        $scope.plans = result.data
        $scope.totalItems = result.originalData.total_items
        $scope.isLoading = false

        sortPlans()

    $scope.filterSubscribedPlan = (plan) ->
      plan.id != $scope.selected_subscription.plan.id

    $scope.changePlanSelect = (plan) ->
      $scope.selected_plan = plan

    $scope.changePlanSubmit = () ->
      if $scope.selected_plan == null
        return

      $scope.loading.show_spinner = true

      params = {
          plan_id: $scope.selected_plan.id
      }
      $http.post('/dashboard/subscriptions/' + $scope.selected_subscription.id  + '/change', params).then(
        (response) ->
          new_subscription = new Subscription(response.data)

          angular.forEach $scope.subscriptions, ((subscription, index) ->
            if subscription.id == new_subscription.id
              scope.subscriptions[index] = new_subscription

              return
          )

          message = "The subscription was successfully changed."
          $scope.display_success_message(message)

          $scope.dismiss_loading()
          change_plan_modal.close()

          $scope.closeEditBar()
        (http)  ->
          errors = http.data

          message = "Sorry, an unexpected error ocurred.  Please try again."
          $scope.display_error_message(message)

          $scope.dismiss_loading()
          change_plan_modal.close()
      )

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
        cancel_subscription_modal = $('[data-remodal-id=cancel-subscription-modal]').remodal($scope.options)

      cancel_subscription_modal.open()

    $scope.cancel_subscription_submit = () ->
      Subscription.setUrl('/dashboard/subscriptions')
      $scope.display_loading()
      $scope.selected_subscription.delete().then(
        () ->
          $scope.selected_subscription.status = "Cancelled"
          $scope.closeEditBar()

          message = "The subscription was successfully deleted."
          $scope.display_success_message(message)

          $scope.dismiss_loading()
          cancel_subscription_modal.close()
        (http)  ->
          errors = http.data

          message = "Sorry, an unexpected error ocurred.  Please try again."
          $scope.display_error_message(message)

          $scope.dismiss_loading()
      )

    $scope.change_plan_clicked = () ->
      if !change_plan_modal
        change_plan_modal = $('[data-remodal-id=change-plan-modal]').remodal($scope.options)

      change_plan_modal.open()

    $scope.change_plan_submit = () ->
      console.log "subscription changed"

    init()

]

SubscriptionsController.$inject = ['$scope', 'Subscription', 'Plan', 'window', '$timeout', '$http']

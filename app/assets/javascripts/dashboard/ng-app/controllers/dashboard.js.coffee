@DashboardController = angular.module('dashboardApp').controller 'DashboardController', [
  '$scope',
  'Account',
  'Plan',
  '$window',
  '$modal',
  '$timeout'
  'AccountServiceChannel'
  ($scope, Account, Plan, window, $modal, $timeout, AccountServiceChannel) ->
    $scope.user = new Account(user)
    $scope.config = config
    $scope.plans = []
    $scope.maxSize = 10

    $scope.loading = {
      show_spinner: false
    }
    $scope.options = {
      "hashTracking": false,
      "closeOnOutsideClick": false
    }
    $scope.show_success_message = false
    $scope.success_message = ""

    $scope.show_error_message = false
    $scope.error_message = ""

    currentModal = null

    $scope.init = () ->
      nav_page_height()

    $scope.set_user = (user) ->
      $scope.user = new Account(user)

    $scope.setCurrentModal = (modal) ->
      currentModal = modal

    $scope.getPlans = () ->
      Plan.get().then (response) ->
        $scope.plans = response.data
    $scope.getPublishableKey = () ->
      if $scope.user.account.paymentProcessors
        return $scope.config.publishableKey
      else
        return ""

    $scope.setMenuItemSelected = (url) ->
      if url == window.location.pathname
        return true

    $scope.display_loading = () ->
      $scope.loading.show_spinner = true

    $scope.dismiss_loading = () ->
      $scope.loading.show_spinner = false

    $scope.display_success_message = (message) ->
      $scope.success_message = message
      $scope.show_success_message = true

      $scope.clear_messages()

    $scope.close_success_message = () ->
      $scope.show_success_message = false

    $scope.display_error_message = (message) ->
      $scope.error_message = message
      $scope.show_error_message = true

      $scope.clear_messages()

    $scope.showEditBar = () ->
      $scope.edit_panel_open = true

    $scope.closeEditBar = () ->
      $scope.edit_panel_open = false

    $scope.close_error_message = () ->
      $scope.show_error_message = false

    $scope.clear_messages = () ->
      $timeout(remove_messages, 4000);

    remove_messages = () ->
      $scope.show_success_message = false
      $scope.show_error_message = false

    $scope.dismissModal = () ->
      currentModal.close()

    $scope.hideLaunchList = () ->
      return $scope.user.account.hasUploadedLogo && $scope.user.account.hasSetupSubdomain && $scope.user.account.hasCreatedPlan && $scope.user.account.hasConnectedStripe && $scope.user.account.hasUpgradedPlan

    onAccountUpdated = () ->
      console.log "Account Updated"

    AccountServiceChannel.onAccountUpdated($scope, onAccountUpdated);

    $scope.getPlans()

    return
]

AccountController.$inject = ['$scope', 'Account', 'Plan', 'window', '$modal', '$timeout', 'AccountServiceChannel']

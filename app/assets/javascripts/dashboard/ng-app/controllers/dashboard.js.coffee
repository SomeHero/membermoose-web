@DashboardController = angular.module('dashboardApp').controller 'DashboardController', [
  '$scope',
  '$rootScope',
  '$window',
  '$state',
  'Account',
  'Plan',
  '$window',
  '$modal',
  '$timeout'
  'AccountServiceChannel',
  'Auth',
  'user',
  'stripe'
  ($scope, $rootScope, $window, $state, Account, Plan, window, $modal, $timeout, AccountServiceChannel, Auth, user, stripe) ->
    currentModal = null

    init = () ->
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

      AccountServiceChannel.onAccountUpdated($scope, onAccountUpdated);

      $scope.getPlans()

      $(document).on 'closed', '.remodal', (e) ->
        # Reason: 'confirmation', 'cancellation'
        if $state.current.name.indexOf("launch_list") > -1
          $state.go('dashboard.launch_list')

      $rootScope.previousState
      $rootScope.currentState
      $rootScope.$on '$stateChangeSuccess', (ev, to, toParams, from, fromParams) ->
        $rootScope.previousState = from.name
        $rootScope.currentState = to.name
        console.log 'Previous state:' + $rootScope.previousState
        console.log 'Current state:' + $rootScope.currentState

    $scope.init = () ->
      nav_page_height()

    $scope.isAuthorized = (role) ->
      if $scope.user.account.role == "superadmin"
        return true
      if $scope.user.account.role == "bull" && (role == 'bull' || role == 'calf')
        return true
      if $scope.user.account.role == "calf" && role == 'calf'
        return true
      return false

    $scope.logout = () ->
      config = headers: 'X-HTTP-Method-Override': 'DELETE'

      Auth.logout(config).then ((oldUser) ->
        # alert(oldUser.name + "you're signed out now.");
        $window.location.href = "/users/sign_in"
      ), (error) ->
        # An error occurred logging out.
        return

    $scope.setUser = (user) ->
      $scope.user = new Account(user)

    $scope.setCurrentModal = (modal) ->
      currentModal = modal

    $scope.getPlans = () ->
      Plan.get().then (response) ->
        $scope.plans = response.data

    $scope.getPublishableKey = () ->
      if $scope.user.account.bull.paymentProcessors
        return $scope.config.publishableKey
      else
        return ""

    $scope.setStripePublishableKey = (paymentProcessors) ->
      stripe.setPublishableKey(paymentProcessors[0].apiKey)

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
      if $scope.user
        return $scope.user.account.hasUploadedLogo && $scope.user.account.hasSetupSubdomain && $scope.user.account.hasCreatedPlan && $scope.user.account.hasConnectedStripe && $scope.user.account.hasUpgradedPlan
      else
        return true

    onAccountUpdated = () ->
      console.log "Account Updated"

    init()

    return
]

AccountController.$inject = ['$scope', '$rootScope', '$window', '$state', 'Account', 'Plan', 'window', '$modal', '$timeout', 'AccountServiceChannel', 'user', 'stripe']

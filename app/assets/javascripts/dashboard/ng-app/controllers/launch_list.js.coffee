@LaunchListController = angular.module('dashboardApp').controller 'LaunchListController', [
  '$scope'
  'Plan'
  '$window'
  'Account'
  '$timeout'
  'fileReader'
  'stripe'
  'Upload'
  'AccountServiceChannel'
  'PlansServiceChannel'
  '$http'
  ($scope, Plan, window, Account, $timeout, fileReader, stripe, Upload, AccountServiceChannel, PlansServiceChannel, $http) ->
    window.scope = $scope
    csrf_token = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

    $scope.active_step = 1
    $scope.select_plan = 0
    $scope.plan = {}
    $scope.image = {
      tempImage: {}
  	}
    upload_logo_modal = null
    setup_subdomain_modal = null
    create_plan_modal = null
    connect_stripe_modal = null
    upgrade_plan_modal = null
    $scope.importedPlans = []
    $scope.plansToImport = []

    $scope.project = {
      steps: {
        step1: $scope.user.account.hasUploadedLogo && $scope.user.account.hasSetupSubdomain,
        step2: $scope.user.account.hasCreatedPlan,
        step3: $scope.user.account.hasConnectedStripe,
        step4: $scope.user.account.hasUpgradedPlan
      }
    }
    $scope.setup_subdomain = {
      subdomain: $scope.user.account.subdomain
    }
    $scope.credit_card = {}

    $scope.upgradePlanClicked = () ->
      if !upgrade_plan_modal
        upgrade_plan_modal = $('[data-remodal-id=upgrade-plan-modal]').remodal($scope.options)

      upgrade_plan_modal.open();
      $scope.setCurrentModal(upgrade_plan_modal)

    $scope.isActiveStep = (step) ->
      if step == $scope.active_step
        return "active-step"

    onAccountUpdated = () ->
      $scope.project.steps.step1 = $scope.user.account.hasUploadedLogo && $scope.user.account.hasSetupSubdomain
      $scope.project.steps.step2 = $scope.user.account.hasCreatedPlan
      $scope.project.steps.step3 = $scope.user.account.hasConnectedStripe
      $scope.project.steps.step4 = $scope.user.account.hasUpgradedPlan

    AccountServiceChannel.onAccountUpdated($scope, onAccountUpdated);

    $scope.init()

    return
]

LaunchListController.$inject = ['$scope', 'Plan', '$window', 'Account', '$timeout', 'fileReader', 'stripe', 'Upload', 'AccountServiceChannel', 'PlansServiceChannel', '$http']

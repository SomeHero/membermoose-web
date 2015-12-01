@CreatePlanController = angular.module('dashboardApp').controller 'CreatePlanController', [
  '$scope'
  '$state'
  'Plan'
  '$modal'
  '$http'
  '$window'
  '$timeout'
  'AccountServiceChannel'
  'PlansServiceChannel'
  ($scope, $state, Plan, $modal, $http, window, $timeout, AccountServiceChannel, PlansServiceChannel) ->
    init = () ->
      $scope.fromLaunch = $state.current.data.fromLaunch
      $scope.newPlanSection = 1
      if $scope.fromLaunch && $scope.user.account.hasCreatedPlan
        $scope.newPlanSection = 7
      $scope.form_submitted = false
      $scope.plan = {
        has_free_trial_period: true
      }
      if !create_plan_modal
        create_plan_modal = $('[data-remodal-id=new-plan-modal]').remodal($scope.options)

      create_plan_modal.open();
      $scope.setCurrentModal(create_plan_modal)

      return

    $scope.isActiveSection = (section) ->
      if section == $scope.newPlanSection
        return "active"

      return ""

    $scope.goToPreviousSection = () ->
      if $scope.newPlanSection == 6 && !$scope.plan.has_free_trial_period
        $scope.newPlanSection = $scope.newPlanSection - 2
      else
        $scope.newPlanSection = $scope.newPlanSection - 1
      $scope.form_submitted = false

    $scope.nextSection = (form) ->
      if form.$valid
        $scope.newPlanSection = $scope.newPlanSection + 1
        $scope.form_submitted = false
      else
        $scope.form_submitted = true


    $scope.hasFreeTrialPeriodClicked = (form) ->
      if $scope.plan.has_free_trial_period
        $scope.newPlanSection = $scope.newPlanSection + 1
      else
        $scope.plan.free_trial_period = 0
        $scope.newPlanSection = $scope.newPlanSection + 2
      $scope.form_submitted = false

    $scope.createPlanClicked = () ->
      $scope.newPlanSection = 1
      if $scope.user.account.hasCreatedPlan
        $scope.newPlanSection = 7
      $scope.form_submitted = false
      $scope.plan = {
        has_free_trial_period: true
      }
      if !create_plan_modal
        create_plan_modal = $('[data-remodal-id=new-plan-modal]').remodal($scope.options)

      create_plan_modal.open();
      $scope.setCurrentModal(create_plan_modal)

    $scope.createPlan = (form)  ->
      if form.$valid
        Plan.setUrl('/dashboard/plans')
        $scope.display_loading()
        $scope.form_submitted = true

        new Plan({
          name: $scope.plan.name,
          description: $scope.plan.description,
          feature_1: $scope.plan.feature_1,
          feature_2: $scope.plan.feature_2,
          feature_3: $scope.plan.feature_3,
          feature_4: $scope.plan.feature_4,
          amount: $scope.plan.amount,
          billing_interval: 1,
          billing_cycle: $scope.plan.billing_cycle,
          free_trial_period: $scope.plan.free_trial_period,
          terms_and_conditions: $scope.plan.terms_and_conditions
        }).create().then(
          (response) ->

            PlansServiceChannel.plansUpdated()

            message = "You successfully created a plan!"
            $scope.display_success_message(message)

            $scope.dismiss_loading()

            if $scope.fromLaunch
              $scope.user.account.hasCreatedPlan = true

              $scope.newPlanSection += 1

              AccountServiceChannel.accountUpdated()
            else
              $scope.newPlanSection = 1

              AccountServiceChannel.accountUpdated()

              $scope.dismissModal()

          (http)  ->
            errors = http.data

            $scope.dismiss_loading()

            message = errors
            $scope.display_error_message(message)
        )
      else
        message = "Failed to Create a Plan"
        $scope.display_error_message(message)

    init()
]

CreatePlanController.$inject = ['$scope', '$state', 'Plan', '$modal', '$http', 'window', '$timeout', 'AccountServiceChannel', 'PlansServiceChannel']

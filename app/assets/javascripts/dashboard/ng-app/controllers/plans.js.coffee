@PlansController = angular.module('dashboardApp').controller 'PlansController', [
  '$scope'
  'Plan'
  '$modal'
  '$window'
  '$timeout'
  'PlansServiceChannel'
  ($scope,  Plan, $modal, window, $timeout, PlansServiceChannel) ->
    window.scope = $scope
    $scope.totalItems = 0
    $scope.currentPage = 1
    $scope.itemsPerPage = 10
    $scope.isLoading = true
    $scope.plan = {}
    $scope.selected_plan = null
    $scope.plans_first_row = []
    $scope.rows = []
    $scope.row_plans = []
    $scope.edit_panel_open = false

    $scope.plans_per_row = 4
    $scope.billing_cycles = [
      'day',
      'week',
      'month',
      'year'
    ];
    $scope.data = {
      billing_interval:  [
        {id: '1', value: '1'},
        {id: '2', value: '2'},
        {id: '3', value: '3'},
        {id: '4', value: '4'},
        {id: '5', value: '5'},
        {id: '6', value: '6'}
      ],
      billing_cycle: [
        {text: 'day', value: 'day'},
        {text: 'month', value: 'month'},
        {text: 'week', value: 'week'},
        {text: 'year', value: 'year'}
      ]
    }
    $scope.newPlanSection = 1
    create_plan_modal  = null
    delete_plan_modal = null
    share_plan_modal = null

    $scope.getPlans = () ->
      Plan.setUrl('/dashboard/plans?page={{page}}')
      Plan.get({page: $scope.currentPage}).then (result) ->
        $scope.plans = result.data
        $scope.totalItems = result.originalData.total_items
        $scope.isLoading = false

        sortPlans()

    $scope.editPlan = (plan) ->
      $scope.edit_panel_open = true
      $scope.selected_plan = angular.copy(plan)

      $scope.plans_per_row = 3
      $scope.$parent.show_success_message = false

      sortPlans()

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

    $scope.newPlanClicked = () ->
      $scope.plan = {
        has_free_trial_period: true
      }
      if !create_plan_modal
        create_plan_modal = $('[data-remodal-id=new-plan-modal]').remodal($scope.options)

      create_plan_modal.open();

    $scope.createPlan = (form)  ->
      if form.$valid
        Plan.setUrl('/dashboard/plans')
        $scope.display_loading()
        $scope.form_submitted = true

        new Plan({
          name: $scope.plan.name,
          description: $scope.plan.description,
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
            $scope.newPlanSection = 1

            create_plan_modal.close()

          (http)  ->
            errors = http.data

            $scope.dismiss_loading()

            message = errors
            $scope.display_error_message(message)
        )
      else
        message = "Failed to Create a Plan"
        $scope.display_error_message(message)

    $scope.updatePlan = (plan, form) ->
      Plan.setUrl('/dashboard/plans')
      if form.$valid
        $scope.display_loading()
        plan.update().then(
          (updated_plan) ->
            angular.forEach($scope.plans, (value,index) =>
              if value.id == updated_plan.id
                $scope.plans[index] = updated_plan
            )
            $scope.closeEditBar()

            message = "Your plan, " + plan.name + ", was successfully updated."
            $scope.display_success_message(message)

            $scope.dismiss_loading()

            PlansServiceChannel.onPlansUpdated()
          (http)  ->
            errors = http.data

            message = errors
            $scope.display_error_message(message)
        )

    $scope.delete_plan_clicked = () ->
      if !delete_plan_modal
        delete_plan_modal = $('[data-remodal-id=delete-plan-modal]').remodal($scope.options)

      delete_plan_modal.open();

    $scope.deletePlan = () ->
      $scope.display_loading()

      Plan.setUrl('/dashboard/plans')
      $scope.selected_plan.delete().then(
        (response) ->
          $scope.dismiss_loading()
          $scope.closeEditBar()

          message = "Your plan, " + $scope.plan.name + ", was successfully deleted."
          $scope.display_success_message(message)

          $scope.getPlans()

          delete_plan_modal.close()
        (http)  ->
          $scope.dismiss_loading()

          errors = http.data

          message = errors
          $scope.display_error_message(message)
      )

    $scope.share_plan_clicked = () ->
      if !share_plan_modal
        share_plan_modal = $('[data-remodal-id=share-plan-modal]').remodal($scope.options)

      share_plan_modal.open();

    $scope.deletePlanCancelled = () ->
      delete_plan_modal.close()

    $scope.showEditBar = () ->
      $scope.edit_panel_open = true

    $scope.closeEditBar = () ->
      $scope.edit_panel_open = false

      $scope.plans_per_row = 4
      sortPlans()

    $scope.setSelectedPlan = (plan) ->
      if(plan == $scope.plan)
        return "selected"
      else
        return ""

    sortPlans = () ->
      $scope.plans_first_row = []
      $scope.rows = []
      $scope.row_plans = []

      angular.forEach($scope.plans, (value,index) =>
        if(index < $scope.plans_per_row - 1)
          $scope.plans_first_row.push($scope.plans[index])
        else
          if(index + 1 > $scope.plans_per_row && ((index + 1) %% $scope.plans_per_row) == 0)
            $scope.rows.push($scope.row_plans)
            $scope.row_plans = []

          $scope.row_plans.push($scope.plans[index])

          if (index) >= $scope.plans.length - 1
            $scope.rows.push($scope.row_plans)
            $scope.row_plans = []
      )

    onPlansUpdated = () ->
      console.log "Plans Updated"

      $scope.getPlans()

    PlansServiceChannel.onPlansUpdated($scope, onPlansUpdated);

    $scope.getPlans()
    $scope.init()

    return
]

PlansController.$inject = ['$scope', 'Plan', '$modal', 'window', '$timeout', 'PlansServiceChannel']

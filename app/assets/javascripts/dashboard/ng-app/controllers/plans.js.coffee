@PlansController = angular.module('dashboardApp').controller 'PlansController', [
  '$scope'
  '$state'
  'Plan'
  '$modal'
  '$http'
  '$window'
  '$timeout'
  '$filter'
  'PlansServiceChannel'
  ($scope, $state, Plan, $modal, $http, window, $timeout, $filter, PlansServiceChannel) ->
    init = () ->
      window.scope = $scope
      $scope.totalItems = 0
      $scope.currentPage = 1
      $scope.itemsPerPage = 10
      $scope.isLoading = true
      $scope.formSubmitted = false
      $scope.plan = {}
      $scope.selected_plan = null
      $scope.plans_first_row = []
      $scope.rows = []
      $scope.row_plans = []
      $scope.edit_panel_open = false

      $scope.plans_per_row = 3
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

      $(document).on 'closed', '.remodal', (e) ->
        # Reason: 'confirmation', 'cancellation'
        if $state.current.name.indexOf("plans") > -1
          $state.go('dashboard.plans')

      PlansServiceChannel.onPlansUpdated($scope, onPlansUpdated);

      $scope.getPlans()
      $scope.init()

    $scope.getPlans = () ->
      Plan.setUrl('/dashboard/plans?page={{page}}')
      Plan.get({page: $scope.currentPage}).then (result) ->
        $scope.plans = result.data
        $scope.totalItems = result.originalData.total_items
        $scope.isLoading = false

    $scope.editPlan = (plan) ->
      $scope.edit_panel_open = true
      $scope.selected_plan = new Plan(angular.copy(plan))
      $scope.selected_plan.amount = $filter('currency')($scope.selected_plan.amount, '', 2)
      $scope.plans_per_row = 3
      $scope.$parent.show_success_message = false

      sortPlans()

    $scope.updatePlan = (plan, form) ->
      Plan.setUrl('/dashboard/plans')
      $scope.formSubmitted = true
      if form.$valid
        $scope.display_loading()
        $scope.selected_plan.update().then(
          (response) ->
            updated_plan = new Plan(response.data)
            angular.forEach($scope.plans, (value,index) =>
              if value.id == updated_plan.id
                $scope.plans[index] = updated_plan
            )

            sortPlans()
            $scope.closeEditBar()

            message = "Your plan, " + updated_plan.name + ", was successfully updated."
            $scope.display_success_message(message)

            $scope.dismiss_loading()

            PlansServiceChannel.onPlansUpdated()
          (http)  ->
            errors = http.data

            message = errors
            $scope.display_error_message(message)
        )
      else
        message = "The form is invalid.  Fix the issues and try again."
        $scope.display_error_message(message)

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

    $scope.createPlanClicked = () ->
      $scope.plan = {
        has_free_trial_period: true
      }
      if !create_plan_modal
        create_plan_modal = $('[data-remodal-id=new-plan-modal]').remodal($scope.options)

      create_plan_modal.open();

    $scope.showSuccessModal = () ->
      false

    $scope.share_plan_clicked = () ->
      if !share_plan_modal
        share_plan_modal = $('[data-remodal-id=share-plan-modal]').remodal($scope.options)

      share_plan_modal.open();

    $scope.showEditBar = () ->
      $scope.edit_panel_open = true

    $scope.closeEditBar = () ->
      $scope.edit_panel_open = false

      $scope.plans_per_row = 3

    $scope.setSelectedPlan = (plan) ->
      if(plan == $scope.plan)
        return "selected"
      else
        return ""

    $scope.showSuccessModal = () ->
      false

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
      $scope.getPlans()

    init()

]

PlansController.$inject = ['$scope', '$state', 'Plan', '$modal', '$http', 'window', '$timeout', '$filter', 'PlansServiceChannel']

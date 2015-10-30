@CreatePlanController = angular.module('dashboardApp').controller 'CreatePlanController', [
  '$scope'
  '$rootScope'
  'Plan'
  '$window'
  '$timeout'
  'PlansServiceChannel'
  ($scope, $rootScope, Plan, window, $timeout, PlansServiceChannel) ->
    window.scope = $scope

    $scope.newPlanSection = 1
    $scope.form_submitted = false
    $scope.loading = {
      show_spinner: false
    }
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

    $scope.isActiveSection = (section) ->
      if section == $scope.newPlanSection
        return "active"

      return ""

    $scope.nextSection = (form) ->
      if form.$valid
        $scope.newPlanSection = $scope.newPlanSection + 1
        $scope.form_submitted = false
      else
        $scope.form_submitted = true

    $scope.createPlan = (form)  ->
      if form.$valid
        Plan.setUrl('/dashboard/plans')
        $scope.loading.show_spinner = true
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

            window.modal.close()

          (http)  ->

            console.log("error creating plan; we should show something")
            $scope.errors = http.data

            $scope.clear_messages()
        )
      else
        console.log "Failed to Create a Plan"

    $scope.clear_messages = () ->
      $timeout(remove_messages, 4000);

    remove_messages = () ->
      $scope.$parent.show_success_message = false

]

CreatePlanController.$inject = ['$scope', '$rootScope', 'Plan', 'window', '$timeout', 'PlansServiceChannel']

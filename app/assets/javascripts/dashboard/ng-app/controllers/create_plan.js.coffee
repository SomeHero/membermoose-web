@CreatePlanController = angular.module('dashboardApp').controller 'CreatePlanController', [
  '$scope'
  'Plan'
  '$modalInstance'
  '$window'
  ($scope, Plan, $modalInstance, window) ->
    window.scope = $scope

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

    $scope.create_plan = (form)  ->
      Plan.setUrl('/dashboard/plans')
      $scope.loading.show_spinner = true
      $scope.form_submitted = true

      new Plan({
        name: $scope.plan.name,
        description: $scope.plan.description,
        amount: $scope.plan.amount,
        billing_interval: $scope.plan.billing_interval,
        billing_cycle: $scope.plan.billing_cycle,
        free_trial_period: $scope.plan.free_trial_period,
        terms_and_conditions: $scope.plan.terms_and_conditions
      }).create().then(
        (response) ->
          $scope.loading.show_spinner = false

          $modalInstance.close();

        (http)  ->
          $scope.loading.show_spinner = false

          console.log("error creating plan; we should show something")
          $scope.errors = http.data
      )
]

CreatePlanController.$inject = ['$scope', 'Plan', '$modalInstance', 'window']

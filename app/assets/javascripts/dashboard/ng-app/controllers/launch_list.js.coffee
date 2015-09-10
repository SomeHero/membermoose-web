@LaunchListController = angular.module('dashboardApp').controller 'LaunchListController', [
  '$scope'
  'Plan'
  '$window'
  ($scope, Plan, $window) ->

    $scope.plan = new Plan()

    $scope.createPlan = (plan) ->
      plan.create().then(
        (plan) ->
          console.log("plan created")
        (http)  ->
          console.log("error creating plan")
          errors = http.data
      )

    $scope.stripe_connect = () ->
      $window.open("http://localhost:3000/users/auth/stripe_connect");
    return
]

LaunchListController.$inject = ['$scope', 'Plan', '$window']

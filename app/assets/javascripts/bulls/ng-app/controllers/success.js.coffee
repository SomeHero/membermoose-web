@SuccessController = angular.module('bullsApp').controller 'SuccessController', [
  '$scope'
  '$stateParams'
  '$window'
  ($scope, $stateParams, window) ->
    $scope.account = account
    $scope.plan_name = $stateParams.plan_name

]
SuccessController.$inject = ['$scope', '$stateParams', 'window']

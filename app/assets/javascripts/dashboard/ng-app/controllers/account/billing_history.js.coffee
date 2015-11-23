@BillingHistoryController = angular.module('dashboardApp').controller 'BillingHistoryController', [
  '$scope'
  '$stateParams'
  '$window'
  ($scope, $stateParams, window) ->
    init = () ->
      window.scope = $scope
      
      $scope.init()

    init()
]
BillingHistoryController.$inject = ['$scope', '$stateParams', 'window']

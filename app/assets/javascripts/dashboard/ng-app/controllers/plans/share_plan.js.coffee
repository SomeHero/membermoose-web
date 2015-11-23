@SharePlanController = angular.module('dashboardApp').controller 'SharePlanController', [
  '$scope'
  'Plan'
  '$modal'
  '$http'
  '$window'
  '$timeout'
  'PlansServiceChannel'
  ($scope,  Plan, $modal, $http, window, $timeout, PlansServiceChannel) ->

    init = () ->
      window.scope = $scope

    init()
]

SharePlanController.$inject = ['$scope', 'Plan', '$modal', '$http', 'window', '$timeout', 'PlansServiceChannel']

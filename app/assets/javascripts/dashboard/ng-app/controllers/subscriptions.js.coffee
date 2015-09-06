@SubscriptionsController = angular.module('dashboardApp').controller 'SubscriptionsController', [
  '$scope'
  'Subscription'
  '$window'
  ($scope, Subscription, window) ->
    $scope.subscription = null
    $scope.subscriptions = []

    $scope.billing_history =  [
      {payment_date:'8/1/2015', amount: 100, status: 'Paid'},
      {payment_date:'7/1/2015', amount: 100, status: 'Paid'},
      {payment_date:'6/1/2015', amount: 100, status: 'Paid'},
      {payment_date:'5/1/2015', amount: 100, status: 'Paid'},
      {payment_date:'4/1/2015', amount: 100, status: 'Paid'},
      {payment_date:'3/1/2015', amount: 100, status: 'Paid'},
    ];
    
    Subscription.get().then (subscriptions) ->
      $scope.subscriptions = subscriptions

    $scope.selectSubscription = (event, subscription) ->
      if $scope.subscription == subscription
        $scope.subscription = null
      else
        $scope.subscription = subscription

    $scope.showEditBar = () ->
      return $scope.subscription != null

    $scope.closeEditBar = () ->
      $scope.subscription = null

    return
]

SubscriptionsController.$inject = ['$scope', 'Subscription', 'window']

var app = angular.module('dashboardApp', [
        'ngAnimate',
        'ui.router',
        'templates',
        'rails',
        'ui.bootstrap',
        'ngTable',
        'uiSwitch',
        'angularFileUpload',
        'loadingScreen',
        'ngFileUpload',
        'rzModule',
        'angular-stripe',
        'Devise'
    ])
    .config(function ($stateProvider, $urlRouterProvider, $locationProvider) {
      $stateProvider
        .state('account', {
            url: '/dashboard/account',
            templateUrl: 'dashboard/ng-app/templates/account.html',
            controller: 'AccountController'
        })
        .state('cards', {
            url: '/dashboard/cards',
            templateUrl: 'dashboard/ng-app/templates/cards.html',
            controller: 'CardsController'
        })
        .state('billing_history', {
            url: '/dashboard/billing',
            templateUrl: 'dashboard/ng-app/templates/billingHistory.html',
            controller: 'BillingHistoryController'
        })
        .state('my_subscriptions', {
            url: '/dashboard/my_subscriptions',
            templateUrl: 'dashboard/ng-app/templates/my_subscriptions.html',
            controller: 'MySubscriptionsController'
        })
        .state('launch_list', {
            url: '/dashboard/launch',
            templateUrl: 'dashboard/ng-app/templates/launch_list.html',
            controller: 'LaunchListController'
        })
        .state('members', {
            url: '/dashboard/members',
            templateUrl: 'dashboard/ng-app/templates/members.html',
            controller: 'MembersController'
        })
        .state('payments', {
            url: '/dashboard/payments',
            templateUrl: 'dashboard/ng-app/templates/payments.html',
            controller: 'PaymentsController'
        })
        .state('plans', {
            url: '/dashboard/plans',
            templateUrl: 'dashboard/ng-app/templates/plans.html',
            controller: 'PlansController'
        })
        .state('subscriptions', {
            url: '/dashboard/subscriptions',
            templateUrl: 'dashboard/ng-app/templates/subscriptions.html',
            controller: 'SubscriptionsController'
        });

        // default fall back route
        $urlRouterProvider.otherwise('/dashboard');

        // enable HTML5 Mode for SEO
        $locationProvider.html5Mode(true);
    });
    angular.module('dashboardApp').config(function (RailsResourceProvider) {
      //RailsResourceProvider.rootWrapping(false);
      RailsResourceProvider.fullResponse(true);
    });
    angular.module('dashboardApp').factory('UserSerializer', function (railsSerializer) {
      return railsSerializer(function () {
          this.nestedAttribute('account', 'account');
      });
    });
    angular.module('dashboardApp').factory('MemberSerializer', function (railsSerializer) {
      return railsSerializer(function () {
          this.nestedAttribute('user', 'user');
      });
    });
    angular.module('dashboardApp').factory('Account', ['railsResourceFactory', function (railsResourceFactory) {
        return railsResourceFactory({
            url: '/dashboard/account',
            name: 'user',
            serializer: 'UserSerializer',
            beforeRequestWrapping: function(httpConfig, resource, context) {
              var mapping, obj, _ref;
            }
        });
    }]);
    angular.module('dashboardApp').factory('Card', ['railsResourceFactory', function (railsResourceFactory) {
        return railsResourceFactory({
            url: '/dashboard/cards',
            name: 'card'
        });
    }]);
    angular.module('dashboardApp').factory('Plan', ['railsResourceFactory', function (railsResourceFactory) {
        return railsResourceFactory({
            url: '/dashboard/plans',
            name: 'plan'
        });
    }]);
    angular.module('dashboardApp').factory('Member', ['railsResourceFactory', function (railsResourceFactory) {
        Member = railsResourceFactory({
            url: '/dashboard/members',
            name: 'member',
            serializer: 'MemberSerializer'
        });

        return Member
    }]);
    angular.module('dashboardApp').factory('Subscription', ['railsResourceFactory', function (railsResourceFactory) {
        return railsResourceFactory({
            url: '/dashboard/subscriptions',
            name: 'subscription'
        });
    }]);
    angular.module('dashboardApp').factory('Payment', ['railsResourceFactory', function (railsResourceFactory) {
        return railsResourceFactory({
            url: '/dashboard/payments',
            name: 'payment'
        });
    }]);
    angular.module('dashboardApp').service('PlansServiceChannel', function ($rootScope) {
        var PLANS_UPDATED_MESSAGE, plansUpdated, onPlansUpdated;
        PLANS_UPDATED_MESSAGE = 'plansUpdatedMessage';
        plansUpdated = function() {
          $rootScope.$broadcast(PLANS_UPDATED_MESSAGE);
        };
        onPlansUpdated = function($scope, handler) {
          $scope.$on(PLANS_UPDATED_MESSAGE, function(event, message) {
            handler();
          });
        };
        return {
          plansUpdated: plansUpdated,
          onPlansUpdated: onPlansUpdated
        };
      }
    );
    angular.module('dashboardApp').service('AccountServiceChannel', function ($rootScope) {
        var ACCOUNT_UPDATED_MESSAGE, accountUpdated, onAccountUpdated;
        ACCOUNT_UPDATED_MESSAGE = 'accountUpdatedMessage';
        accountUpdated = function() {
          $rootScope.$broadcast(ACCOUNT_UPDATED_MESSAGE);
        };
        onAccountUpdated = function($scope, handler) {
          $scope.$on(ACCOUNT_UPDATED_MESSAGE, function(event, message) {
            handler();
          });
        };
        return {
          accountUpdated: accountUpdated,
          onAccountUpdated: onAccountUpdated
        };
      }
    );
app.run(function($rootScope) {
  // you can inject any instance here
});

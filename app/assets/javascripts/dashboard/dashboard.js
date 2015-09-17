var app = angular.module('dashboardApp', [
        'ngAnimate',
        'ui.router',
        'templates',
        'rails',
        'ui.bootstrap',
        'ngTable',
        'uiSwitch'
    ])
    .config(function ($stateProvider, $urlRouterProvider, $locationProvider) {
      $stateProvider
        .state('launch', {
            url: '/dashboard/launch',
            controller: 'LaunchController'
        })
        .state('account', {
            url: '/dashboard/account/:id/edit',
            templateUrl: 'dashboard/ng-app/templates/account.html',
            controller: 'AccountController'
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
            serializer: 'UserSerializer'
        });
    }]);
    angular.module('dashboardApp').factory('Plan', ['railsResourceFactory', function (railsResourceFactory) {
        return railsResourceFactory({
            url: '/dashboard/plans',
            name: 'plan'
        });
    }]);
    angular.module('dashboardApp').factory('Member', ['railsResourceFactory', function (railsResourceFactory) {
        return railsResourceFactory({
            url: '/dashboard/members',
            name: 'member',
            serializer: 'MemberSerializer'
        });
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

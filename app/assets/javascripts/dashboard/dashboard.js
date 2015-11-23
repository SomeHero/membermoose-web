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
        .state('dashboard', {
          abstract: true,
          url: '/dashboard',
          controller: 'DashboardController',
          templateUrl: 'dashboard/ng-app/templates/dashboard.html',
          resolve: {
            user: function(Auth) {
              return Auth.currentUser();
            }
          }
        })
        .state('dashboard.account', {
            url: '/account',
            templateUrl: 'dashboard/ng-app/templates/account.html',
            controller: 'AccountController'
        })
        .state('dashboard.change_password', {
            url: '/account/change_password',
            templateUrl: 'dashboard/ng-app/templates/change_password.html',
            controller: 'ChangePasswordController'
        })
        .state('dashboard.cards', {
            url: '/cards',
            templateUrl: 'dashboard/ng-app/templates/cards.html',
            controller: 'CardsController'
        })
        .state('dashboard.billing_history', {
            url: '/billing',
            templateUrl: 'dashboard/ng-app/templates/billingHistory.html',
            controller: 'BillingHistoryController'
        })
        .state('dashboard.my_subscriptions', {
            url: '/my_subscriptions',
            templateUrl: 'dashboard/ng-app/templates/my_subscriptions.html',
            controller: 'MySubscriptionsController'
        })
        .state('dashboard.launch_list', {
          url: '/launch',
          templateUrl: 'dashboard/ng-app/templates/launch_list.html',
          controller: 'LaunchListController'
        })
        .state('dashboard.launch_list.upload_logo', {
          url: '/upload_logo',
          templateUrl: 'dashboard/ng-app/templates/launchlist/upload_logo.html',
          controller: 'UploadLogoController'
        })
        .state('dashboard.launch_list.setup_subdomain', {
          url: '/setup_subdomain',
          templateUrl: 'dashboard/ng-app/templates/launchlist/choose_subdomain.html',
          controller: 'ChooseSubdomainController'
        })
        .state('dashboard.launch_list.create_plan', {
          url: '/plan',
          templateUrl: 'dashboard/ng-app/templates/plans/new_plan.html',
          controller: 'CreatePlanController',
          data: {
            fromLaunch: true
          }
        })
        .state('dashboard.launch_list.connect_stripe', {
          url: '/connect_stripe',
          templateUrl: 'dashboard/ng-app/templates/launchlist/connect_stripe.html',
          controller: 'ConnectStripeController'
        })
        .state('dashboard.launch_list.upgrade_plan', {
          url: '/upgrade',
          templateUrl: 'dashboard/ng-app/templates/launchlist/upgrade_plan.html',
          controller: 'UpgradePlanController'
        })
        .state('dashboard.members', {
            url: '/members',
            templateUrl: 'dashboard/ng-app/templates/members.html',
            controller: 'MembersController'
        })
        .state('dashboard.payments', {
            url: '/payments',
            templateUrl: 'dashboard/ng-app/templates/payments.html',
            controller: 'PaymentsController'
        })
        .state('dashboard.plans', {
            url: '/plans',
            templateUrl: 'dashboard/ng-app/templates/plans.html',
            controller: 'PlansController'
        })
        .state('dashboard.subscriptions', {
            url: '/subscriptions',
            templateUrl: 'dashboard/ng-app/templates/subscriptions.html',
            controller: 'SubscriptionsController'
        });

        // default fall back route
        $urlRouterProvider.otherwise('/dashboard/plans');

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

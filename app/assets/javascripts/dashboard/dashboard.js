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
        .state('dashboard.account.upload_logo', {
            url: '/upload_logo',
            templateUrl: 'dashboard/ng-app/templates/account/upload_logo.html',
            controller: 'UploadLogoController',
            data: {
              fromLaunch: false
            }
        })
        .state('dashboard.account.upgrade_plan', {
            url: '/upgrade_plan',
            templateUrl: 'dashboard/ng-app/templates/account/upgrade_plan.html',
            controller: 'UpgradePlanController',
            data: {
              fromLaunch: false
            }
        })
        .state('dashboard.logout', {
            url: '/logout',
            templateUrl: 'dashboard/ng-app/templates/account/logout.html',
            controller: 'LogoutConfirmationController'
        })
        .state('dashboard.change_password', {
            url: '/account/change_password',
            templateUrl: 'dashboard/ng-app/templates/account/change_password.html',
            controller: 'ChangePasswordController'
        })
        .state('dashboard.cards', {
            url: '/cards',
            templateUrl: 'dashboard/ng-app/templates/account/cards.html',
            controller: 'CardsController'
        })
        .state('dashboard.cards.destroy', {
            url: '/destroy',
            templateUrl: 'dashboard/ng-app/templates/account/cards/delete_card.html',
            controller: 'DeleteCardController',
            params: { card: null }
        })
        .state('dashboard.cards.update', {
            url: '/update',
            templateUrl: 'dashboard/ng-app/templates/account/cards/update_card.html',
            controller: 'UpdateCardController',
            params: { card: null }
        })
        .state('dashboard.billing_history', {
            url: '/billing',
            templateUrl: 'dashboard/ng-app/templates/account/billing_history.html',
            controller: 'BillingHistoryController'
        })
        .state('dashboard.my_subscriptions', {
            url: '/my_subscriptions',
            templateUrl: 'dashboard/ng-app/templates/account/my_subscriptions.html',
            controller: 'MySubscriptionsController'
        })
        .state('dashboard.my_subscriptions.unsubscribe', {
            url: '/unsubscribe',
            templateUrl: 'dashboard/ng-app/templates/account/my_subscriptions/unsubscribe.html',
            controller: 'UnsubscribeController',
            params: { subscription: null }
        })
        .state('dashboard.my_subscriptions.upgrade', {
            url: '/upgrade',
            templateUrl: 'dashboard/ng-app/templates/account/my_subscriptions/change_plan.html',
            controller: 'ChangeSubscriptionController',
            params: { subscription: null }
        })
        .state('dashboard.launch_list', {
          url: '/launch',
          templateUrl: 'dashboard/ng-app/templates/launch_list.html',
          controller: 'LaunchListController'
        })
        .state('dashboard.launch_list.upload_logo', {
          url: '/upload_logo',
          templateUrl: 'dashboard/ng-app/templates/launchlist/upload_logo.html',
          controller: 'UploadLogoController',
          data: {
            fromLaunch: true
          }
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
          controller: 'UpgradePlanController',
          data: {
            fromLaunch: true
          }
        })
        .state('dashboard.members', {
            url: '/members',
            templateUrl: 'dashboard/ng-app/templates/members.html',
            controller: 'MembersController'
        })
        .state('dashboard.members.next_invoice', {
            url: '/next_invoice',
            templateUrl: 'dashboard/ng-app/templates/members/next_invoice.html',
            controller: 'NextInvoiceController'
        })
        .state('dashboard.members.add_card', {
            url: '/add_card',
            templateUrl: 'dashboard/ng-app/templates/members/cards/add_card.html',
            controller: 'MemberAddCardController',
            params: { member: null }
        })
        .state('dashboard.members.update_card', {
            url: '/update_card',
            templateUrl: 'dashboard/ng-app/templates/members/cards/update_card.html',
            controller: 'MemberUpdateCardController',
            params: { member: null }
        })
        .state('dashboard.members.delete_card', {
            url: '/delete_card',
            templateUrl: 'dashboard/ng-app/templates/members/cards/delete_card.html',
            controller: 'MemberDeleteCardController',
            params: { member: null }
        })
        .state('dashboard.payments', {
            url: '/payments',
            templateUrl: 'dashboard/ng-app/templates/payments.html',
            controller: 'PaymentsController'
        })
        .state('dashboard.payments.refund', {
            url: '/refund',
            templateUrl: 'dashboard/ng-app/templates/payments/refund_payment.html',
            controller: 'RefundPaymentsController'
        })
        .state('dashboard.plans', {
            url: '/plans',
            templateUrl: 'dashboard/ng-app/templates/plans.html',
            controller: 'PlansController'
        })
        .state('dashboard.plans.create', {
            url: '/create',
            templateUrl: 'dashboard/ng-app/templates/plans/new_plan.html',
            controller: 'CreatePlanController',
            data: {
              fromLaunch: false
            }
        })
        .state('dashboard.plans.delete', {
            url: '/delete',
            templateUrl: 'dashboard/ng-app/templates/plans/delete_plan.html',
            controller: 'DeletePlanController',
            params: { plan: null }
        })
        .state('dashboard.plans.share', {
            url: '/share',
            templateUrl: 'dashboard/ng-app/templates/plans/share_plan.html',
            controller: 'SharePlanController',
            params: { plan: null }
        })
        .state('dashboard.subscriptions', {
            url: '/subscriptions',
            templateUrl: 'dashboard/ng-app/templates/subscriptions.html',
            controller: 'SubscriptionsController'
        })
        .state('dashboard.subscriptions.unsubscribe', {
            url: '/unsubscribe',
            templateUrl: 'dashboard/ng-app/templates/subscriptions/cancel_subscription.html',
            controller: 'CancelSubscriptionController',
            params: { subscription: null }
        })
        .state('dashboard.subscriptions.change_plan', {
            url: '/change_plan',
            templateUrl: 'dashboard/ng-app/templates/subscriptions/change_plan.html',
            controller: 'ChangePlanController',
            params: { subscription: null }
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
    angular.module('dashboardApp').factory('MySubscription', ['railsResourceFactory', function (railsResourceFactory) {
        return railsResourceFactory({
            url: '/dashboard/my_subscriptions',
            name: 'my_subscription'
        });
    }]);
    angular.module('dashboardApp').factory('Payment', ['railsResourceFactory', function (railsResourceFactory) {
        return railsResourceFactory({
            url: '/dashboard/payments',
            name: 'payment'
        });
    }]);
    angular.module('dashboardApp').factory('BullPlan', ['railsResourceFactory', function (railsResourceFactory) {
        return railsResourceFactory({
            url: '/dashboard/bulls/plans',
            name: 'bullplan'
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

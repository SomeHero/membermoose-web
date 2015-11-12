var dashboardApp = angular.module('dashboardApp', [
        'ngAnimate',
        'ui.router',
        'templates',
        'rails',
        'ui.bootstrap'
    ])
    .config(function ($stateProvider, $urlRouterProvider, $locationProvider) {
      $stateProvider
        .state('subscriptions', {
            url: '/dashboard',
            templateUrl: 'bulls/ng-dashboard-app/templates/subscriptions.html',
            controller: 'SubscriptionsController'
        })
        .state('cards', {
            url: '/cards',
            templateUrl: 'bulls/ng-dashboard-app/templates/cards.html',
            controller: 'CardsController'
        })
        .state('billingHistory', {
            url: '/billing',
            templateUrl: 'bulls/ng-dashboard-app/templates/billingHistory.html',
            controller: 'BillingHistoryController'
        })

        // default fall back route
        $urlRouterProvider.otherwise('/');

        // enable HTML5 Mode for SEO
        $locationProvider.html5Mode(true);
    });
    angular.module('dashboardApp').config(function (RailsResourceProvider) {
      //RailsResourceProvider.rootWrapping(false);
      RailsResourceProvider.fullResponse(true);
    });
    angular.module('dashboardApp').factory('Subscription', ['railsResourceFactory', function (railsResourceFactory) {
        return railsResourceFactory({
            url: '/bulls/subscriptions',
            name: 'subscription'
        });
    }]);
    angular.module('dashboardApp').factory('Plan', ['railsResourceFactory', function (railsResourceFactory) {
        return railsResourceFactory({
            url: '/bulls/plans',
            name: 'plan'
        });
    }]);

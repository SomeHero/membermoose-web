var app = angular.module('bullsApp', [
        'ngAnimate',
        'ui.router',
        'templates',
        'rails',
        'ui.bootstrap',
        'loadingScreen',
        'angular-stripe'
    ])
    .config(function ($stateProvider, $urlRouterProvider, $locationProvider) {
      $stateProvider
        .state('plans', {
            url: '/',
            templateUrl: 'bulls/ng-app/templates/plans.html',
            controller: 'PlansController'
        })
        .state('subscribe', {
            url: '/subscribe/:id',
            templateUrl: 'bulls/ng-app/templates/subscribe.html',
            controller: 'SubscribeController',
            resolve: {
              plan: function($http, $stateParams) {
                return $http.get('/bulls/plans/' + $stateParams.id)
              }
            }
        })
        .state('success', {
            url: '/success',
            templateUrl: 'bulls/ng-app/templates/success.html',
            controller: 'SuccessController',
            params: {plan_name: ""}
        })

        // default fall back route
        $urlRouterProvider.otherwise('/');

        // enable HTML5 Mode for SEO
        $locationProvider.html5Mode(true);
    });
    angular.module('bullsApp').config(function (RailsResourceProvider) {
      //RailsResourceProvider.rootWrapping(false);
      RailsResourceProvider.fullResponse(true);
    });
    angular.module('bullsApp').factory('Account', ['railsResourceFactory', function (railsResourceFactory) {
        return railsResourceFactory({
            url: '/bulls/account',
            name: 'user',
            serializer: 'UserSerializer'
        });
    }]);
    angular.module('bullsApp').factory('Plan', ['railsResourceFactory', function (railsResourceFactory) {
        return railsResourceFactory({
            url: '/bulls/plans',
            name: 'plan'
        });
    }]);
    angular.module('bullsApp').factory('Subscription', ['railsResourceFactory', function (railsResourceFactory) {
        return railsResourceFactory({
            url: '/bulls/subscriptions',
            name: 'subscription'
        });
    }]);

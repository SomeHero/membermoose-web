var app = angular.module('bullsApp', [
        'ngAnimate',
        'ui.router',
        'templates',
        'rails',
        'ui.bootstrap'
    ])
    .config(function ($stateProvider, $urlRouterProvider, $locationProvider) {
      $stateProvider
        .state('plans', {
            url: '/bulls/plans',
            templateUrl: 'bulls/ng-app/templates/plans.html',
            controller: 'PlansController'
        })

        // default fall back route
        $urlRouterProvider.otherwise('/plans');

        // enable HTML5 Mode for SEO
        $locationProvider.html5Mode(true);
    });
    angular.module('bullsApp').config(function (RailsResourceProvider) {
      //RailsResourceProvider.rootWrapping(false);
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

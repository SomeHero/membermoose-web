var app = angular.module('dashboardApp', [
        'ngAnimate',
        'ui.router',
        'templates',
        'rails'
    ])
    .config(function ($stateProvider, $urlRouterProvider, $locationProvider) {
      $stateProvider
        .state('account', {
            url: '/account',
            templateUrl: 'dashboard/ng-app/templates/account.html',
            controller: 'AccountController'
        })
        .state('plans', {
            url: '/plans',
            templateUrl: 'dashboard/ng-app/templates/plans.html',
            controller: 'PlansController'
        });

        // default fall back route
        $urlRouterProvider.otherwise('/account');

        // enable HTML5 Mode for SEO
        $locationProvider.html5Mode(false);
    });
    angular.module('dashboardApp').config(function (RailsResourceProvider) {
      //RailsResourceProvider.rootWrapping(false);
    });
    angular.module('dashboardApp').factory('UserSerializer', function (railsSerializer) {
      return railsSerializer(function () {
          this.nestedAttribute('account', 'account');
      });
    });
    angular.module('dashboardApp').factory('Account', ['railsResourceFactory', function (railsResourceFactory) {
        return railsResourceFactory({
            url: '/account',
            name: 'user',
            serializer: 'UserSerializer'
        });
    }]);

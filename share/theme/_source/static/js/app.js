var gfsbApp = angular.module('gfsbApp', [
  'ngRoute',
  'gfsbAnimations',

  'gfsbControllers',
  'gfsbFilters',
  'gfsbServices'
]);

gfsbApp.config(['$routeProvider', '$locationProvider',
  function($routeProvider, $locationProvider) {
    $routeProvider.
      when('/products', {
        templateUrl: 'partials/product-list.html',
        controller: 'ProductListCtrl'
      }).
      when('/products/:productId', {
        templateUrl: 'partials/product-detail.html',
        controller: 'ProductDetailCtrl'
      }).
      otherwise({
        redirectTo: '/products'
      });
      //$locationProvider.html5Mode(true);

  }]);

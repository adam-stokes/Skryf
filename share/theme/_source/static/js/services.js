/* Services */

var gfsbServices = angular.module('gfsbServices', ['ngResource']);

gfsbServices.factory('Product', ['$resource',
  function($resource){
    return $resource('/api/products', {}, {
      query: {method:'GET', params:{}, isArray:true}
    });
  }]);

gfsbServices.factory('ProductDetail', ['$resource',
  function($resource){
    return $resource('/api/product/:productId', {}, {
      query: {method:'GET', params:{productId:'products'}, isArray:true}
    });
  }]);

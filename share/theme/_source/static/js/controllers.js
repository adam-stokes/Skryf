/* Controllers */

var gfsbControllers = angular.module('gfsbControllers', []);

gfsbControllers.controller('ProductListCtrl', ['$scope', 'Product',
    function($scope, Product) {
        $scope.products = Product.query();
        $scope.orderProp = 'title';
    }
]);

gfsbControllers.controller('ProductDetailCtrl', ['$scope', '$routeParams', 'ProductDetail',
    function($scope, $routeParams, ProductDetail) {
        $scope.product = ProductDetail.get({
            productId: $routeParams.productId
        }, function(product) {
            $scope.mainImageUrl = product.images[0];
        });

        $scope.setImage = function(imageUrl) {
            $scope.mainImageUrl = imageUrl;
        };
    }
]);

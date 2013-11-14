'use strict'

angular.module 'DiamondCollectorApp', ['ngRoute']
  .config <[$routeProvider]> ++ ($routeProvider) ->
    $routeProvider.when '/', {
      templateUrl: 'views/main.html'
      controller: 'MainCtrl'
    }
    .otherwise {
      redirectTo: '/'
    }

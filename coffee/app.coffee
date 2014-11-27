tornadoChat = angular.module 'tornadoChat', ['ngRoute']

tornadoChat.config [ '$routeProvider', ($routeProvider) ->
    $routeProvider.when '/',
        templateUrl: '/angular_templates/home.html'
        controller: 'mainCtrl'
]

tornadoChat.controller 'mainCtrl',[ '$scope', ($scope) ->
    $scope.message = "lolilol"
]

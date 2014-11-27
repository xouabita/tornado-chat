tornadoChat = angular.module 'tornadoChat', ['ngRoute']

tornadoChat.config [ '$routeProvider', '$locationProvider', ($routeProvider, $locationProvider) ->
    $routeProvider.when '/',
        templateUrl: '/angular_templates/home.html'
        controller: 'mainCtrl'

    $locationProvider.html5Mode yes
]

tornadoChat.controller 'mainCtrl',[ '$scope', ($scope) ->
    $scope.message = "lolilol"
]

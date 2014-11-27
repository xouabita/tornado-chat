tornadoChat = angular.module 'tornadoChat', ['ngRoute']

tornadoChat.config [ '$routeProvider', '$locationProvider', ($routeProvider, $locationProvider) ->
    $routeProvider.when '/',
        templateUrl: '/angular_templates/home.html'
        controller: 'homeCtrl'

    $locationProvider.html5Mode yes
]

tornadoChat.controller 'homeCtrl', ['$scope', '$http', ($scope, $http) ->
    $http
        method: 'get'
        url: '/chatrooms'
    .success (rooms) ->
        $scope.rooms = rooms
]

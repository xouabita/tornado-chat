tornadoChat = angular.module 'tornadoChat', ['ngRoute']

# ~~~~~~~~~~~~~
#     Routes
# ~~~~~~~~~~~~~
tornadoChat.config [ '$routeProvider', '$locationProvider', ($routeProvider, $locationProvider) ->
    $routeProvider.when '/',
        templateUrl: '/angular_templates/home.html'
        controller: 'homeCtrl'

    $locationProvider.html5Mode yes
]

# ~~~~~~~~~~~~~~~~~~~~~~~~
# Controller for homepage
# ~~~~~~~~~~~~~~~~~~~~~~~~
tornadoChat.controller 'homeCtrl', ['$scope', '$http', ($scope, $http) ->

    # Load the list of chatrooms
    $http
        method: 'get'
        url: '/chatrooms'
    .success (rooms) ->
        $scope.rooms = rooms

    # Create new chatroom
    $scope.newRoom = ->
        # get the value
        roomTitle = document.getElementById('room-title').value
        $http
            method: 'post'
            url: '/chatrooms'
            data:
                title: roomTitle
        .success ->
            document.getElementById('room-title').value = ""
]

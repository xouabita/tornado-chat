tornadoChat = angular.module 'tornadoChat', ['ngRoute']

# ~~~~~~~~~~~~~
#     Routes
# ~~~~~~~~~~~~~
tornadoChat.config [ '$routeProvider', '$locationProvider', ($routeProvider, $locationProvider) ->
    $routeProvider.when '/',
        templateUrl: '/angular_templates/home.html'
        controller: 'homeCtrl'

    $routeProvider.when '/chatroom/:id',
        templateUrl: '/angular_templates/chatroom.html'
        controller: 'chatroomCtrl'

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

# ~~~~~~~~~~~~~~~~~~~~~~~
# Controller for chatroom
# ~~~~~~~~~~~~~~~~~~~~~~~
tornadoChat.controller 'chatroomCtrl', ['$scope', '$http', '$route', ($scope, $http, $route) ->
    $http
        method: 'get'
        url: "/chatrooms/#{$route.current.params.id}"
    .success (room) ->
        $scope.room = room
]

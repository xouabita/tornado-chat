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

    $scope.ws = undefined
    openWS = ->
        $scope.ws = new WebSocket "ws://localhost:8888/roomsocket/#{$scope.room._id}"
        $scope.ws.onmessage = (e) ->
            $scope.room.messages.push JSON.parse(e.data)
            $scope.$digest()
        $scope.onclose = (e) -> openWS()

    $http
        method: 'get'
        url: "/chatrooms/#{$route.current.params.id}"
    .success (room) ->
        $scope.room = room
        openWS()

    $scope.postMsg = ->
        # get the value
        message = document.getElementById('message').value
        if message != ""
            $http
                method: 'post'
                url: "/chatrooms/#{$scope.room._id}"
                data:
                    username: "xou"
                    message: message
            .success ->
                document.getElementById('message').value = ""
]

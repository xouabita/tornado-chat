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

# ~~~~~~~~~~~~~~~
# Main Controller
# ~~~~~~~~~~~~~~~
tornadoChat.controller 'mainCtrl', [ '$scope', ($scope) ->
    # Check if the user pick already a username
    $scope.username = undefined
    if localStorage.username then $scope.username = localStorage.username
    $scope.saveUsername = ->
        username = document.getElementById('username-input').value
        if username
            localStorage.username = username
            $scope.username = username
    $scope.logout = ->
        delete localStorage.username
        $scope.username = undefined
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
        .success (room) ->
            document.getElementById('room-title').value = ""
            $scope.rooms.push room
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
                    username: $scope.username
                    message: message
            .success ->
                document.getElementById('message').value = ""
]

# ~~~~~~~~~~~~~~~~
#    Directives
# ~~~~~~~~~~~~~~~~
tornadoChat.directive 'modal', ->
    restrict: 'C'
    link: (scope, element, attrs) ->
        scope.$watch attrs.visible, (val) ->
            if not val then $(element).modal keyboard:no, backdrop: 'static'
            else $(element).modal 'hide'

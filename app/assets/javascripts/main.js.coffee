@znote = angular.module 'znote', ['ngRoute', 'noteControllers', 'searchControllers']

@znote.config ['$routeProvider', ($routeProvider) -> 
  $routeProvider.
    when('/note/view/:note_id', {
      templateUrl: '/partials/note_view',
      controller: 'NoteDetailCtrl'
    }).
    when('/note/new', {
      templateUrl: '/partials/note_new',
      controller: 'NoteNewCtrl'
    })
]

@noteCtrl = angular.module 'noteControllers', []

@noteCtrl.controller 'NoteDetailCtrl', ['$scope', '$routeParams', '$http', ($scope, $routeParams, $http) ->
  $http.get '/note/view/' + $routeParams.note_id
    .success (data, status) ->
      $scope.title = data.title
      $scope.content = data.content
]

@noteCtrl.controller 'NoteNewCtrl', ['$scope', '$http', '$location', ($scope, $http, $location) ->
  $scope.saveNote = ->
    $http.post '/note/new', {title: $scope.noteTitle, content: $scope.noteContent}
      .success (data, status) ->
        $location.path("/note/view/#{data.id}")
      .error (data, status) ->
        alert "Failed"
]

@searchControllers = angular.module 'searchControllers', []

@searchControllers.controller 'searchCtrl', ['$scope', '$http', ($scope, $http) ->
  $scope.$watch 'searchText', (newVal, oldVal) ->
    if newVal.length > 3
      $http.post '/note/search', {term: newVal}
        .success (data, status) ->
          $scope.results = data
]

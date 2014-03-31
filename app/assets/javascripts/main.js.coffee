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
    }).
    when('/note/:note_id/edit', {
      templateUrl: '/partials/note_edit',
      controller: 'NoteEditCtrl'
    }).
    when('/note/:note_id/delete', {
      template: ' '
      controller: 'NoteDeleteCtrl'
    }).
    when('/',{
      template: ' '
      controller: 'RootCtrl'
    }).
    otherwise({
      redirectTo: '/'
    })
]

@noteCtrl = angular.module 'noteControllers', ['ngSanitize', 'ui.codemirror']

@noteCtrl.controller 'NoteDetailCtrl', ['$scope', '$routeParams', '$http', '$rootScope', ($scope, $routeParams, $http, $rootScope) ->
  $http.get '/note/view/' + $routeParams.note_id
    .success (data, status) ->
      $scope.title = data.title
      $scope.content = data.content_html
      $("#note_edit").attr("href", "#/note/#{data.id}/edit")
      $("#note_delete").attr("href", "#/note/#{data.id}/delete")
      $('#content-holder').perfectScrollbar
        wheelSpeed: 20,
        wheelPropagation: false
      $rootScope.$broadcast('RELOAD_LATEST_NOTE')
    .error (data, status) ->
      alert(data)
]

@noteCtrl.controller 'NoteNewCtrl', ['$scope', '$http', '$location', '$rootScope', ($scope, $http, $location, $rootScope) ->
  $("#note_edit").removeAttr("href")
  $("#note_delete").removeAttr("href")
  $scope.editorOptions = 
    mode: 'markdown'
    theme: 'paraiso-light'
  $scope.saveNote = ->
    $http.post '/note/new', {title: $scope.noteTitle, content: $scope.noteContent}
      .success (data, status) ->
        $rootScope.$broadcast('ROOT_CALLED')
        $location.path("/note/view/#{data.id}")
      .error (data, status) ->
        alert "Create Failed"
  $scope.cancelNote = ->
    $location.path "/"
]

@noteCtrl.controller 'NoteEditCtrl', ['$scope', '$routeParams', '$http', '$location', '$rootScope', ($scope, $routeParams, $http, $location, $rootScope) ->
  $scope.editorOptions = 
    mode: 'markdown'
    theme: 'paraiso-light'
    indentUnit: 4
    extraKeys:
      Tab: (cm)->
        spaces = Array(cm.getOption("indentUnit") + 1).join(" ")
        cm.replaceSelection(spaces)

  $http.get '/note/view/' + $routeParams.note_id
    .success (data, status) ->
      $scope.noteId = data.id
      $scope.noteTitle = data.title
      $scope.noteContent = data.content

  $scope.saveNote = ->
    $http.post '/note/edit', {id: $scope.noteId, title: $scope.noteTitle, content: $scope.noteContent}
      .success (data, status) ->
        $rootScope.$broadcast('ROOT_CALLED');
        $location.path("/note/view/#{data.id}")
      .error (data, status) ->
        alert "Update Failed"
  $scope.cancelEdit = ->
    $location.path("/note/view/#{$scope.noteId}")
]

@noteCtrl.controller 'NoteDeleteCtrl', ['$scope', '$routeParams', '$http', '$location', ($scope, $routeParams, $http, $location) ->
  $http.get "/note/#{$routeParams.note_id}/delete"
    .success (data, status) ->
      $("#note_edit").removeAttr("href")
      $("#note_delete").removeAttr("href")
      $location.path "/"
    .error (data, status) ->
      alert "Delete failed"
]

@noteCtrl.controller 'RootCtrl', ['$scope', '$rootScope', ($scope, $rootScope) ->
  $rootScope.$broadcast('ROOT_CALLED');
]

@searchControllers = angular.module 'searchControllers', []

@searchControllers.controller 'searchCtrl', ['$scope', '$http', '$location', ($scope, $http, $location) ->
  $scope.$on 'ROOT_CALLED', (event, args) ->
    $http.get '/notes/latest'
      .success (data, status) ->
        $scope.searchText = ''
        $scope.results = data
        if data.length > 0
          $location.path("/note/view/#{data[0].id}")

  $scope.$on 'RELOAD_LATEST_NOTE', (event, args) ->
    unless $scope.results?
      $http.get '/notes/latest'
        .success (data, status) ->
          $scope.results = data

  $scope.$watch 'searchText', (newVal, oldVal) ->
    if newVal.length > 3
      $http.post '/note/search', {term: newVal}
        .success (data, status) ->
          $scope.results = data
    else
      $http.get '/notes/latest'
        .success (data, status) ->
          $scope.results = data
]

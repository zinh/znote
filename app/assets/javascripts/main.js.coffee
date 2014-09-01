share = (id)->
  alert("Share note #{id}")

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
    when('/note/:note_id/share', {
      template: ' '
      controller: 'NoteShareCtrl'
    }).
    when('/',{
      template: ' '
      controller: 'RootCtrl'
    }).
    otherwise({
      redirectTo: '/'
    })
]

@noteCtrl = angular.module 'noteControllers', ['ui.codemirror']

@noteCtrl.controller 'NoteDetailCtrl', ['$scope', '$routeParams', '$http', '$rootScope', '$sce', ($scope, $routeParams, $http, $rootScope, $sce) ->
  $http.get '/note/view/' + $routeParams.note_id
    .success (data, status) ->
      $scope.title = data.title
      $scope.content = $sce.trustAsHtml(data.content_html)
      $("#note_edit").attr("href", "#/note/#{data.id}/edit")
      $("#note_delete").attr("href", "#/note/#{data.id}/delete")
      $("#note_share").attr("href", "javascript:share(#{data.id})")
      $('#content-holder').perfectScrollbar
        wheelSpeed: 20,
        wheelPropagation: false
      $rootScope.$broadcast('RELOAD_LATEST_NOTE', [data.id])
    .error (data, status) ->
      alert(data)
]

@noteCtrl.controller 'NoteNewCtrl', ['$scope', '$http', '$location', '$rootScope', ($scope, $http, $location, $rootScope) ->
  $("#note_edit").removeAttr("href")
  $("#note_delete").removeAttr("href")
  $("#note_share").removeAttr("href")
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

@noteCtrl.controller 'NoteEditCtrl', ['$scope', '$routeParams', '$http', '$location', '$rootScope', '$interval', ($scope, $routeParams, $http, $location, $rootScope, $interval) ->
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

  autoSave = $interval(
    ->
      $http.post '/note/edit', {id: $scope.noteId, title: $scope.noteTitle, content: $scope.noteContent}
        .success (data, status) ->
          currentdate = new Date()
          $("#autosave").text("Autosave at " + currentdate.getHours() + ':' + currentdate.getMinutes())
    60000
  )

  $scope.$on('$destroy', ->
    $interval.cancel(autoSave)
    autoSave = undefined
  )
]

@noteCtrl.controller 'NoteDeleteCtrl', ['$scope', '$routeParams', '$http', '$location', ($scope, $routeParams, $http, $location) ->
  $http.get "/note/#{$routeParams.note_id}/delete"
    .success (data, status) ->
      $("#note_edit").removeAttr("href")
      $("#note_delete").removeAttr("href")
      $("#note_share").removeAttr("href")
      $location.path "/"
    .error (data, status) ->
      alert "Delete failed"
]

@noteCtrl.controller 'NoteShareCtrl', ['$scope', '$routeParams', '$http', '$location', ($scope, $routeParams, $http, $location) ->
  $http.get "/note/#{$routeParams.note_id}/share"
    .success (data, status) ->
      alert(data.id)
      event.preventDefault
    .error (data, status) ->
      alert "Share failed"
]

@noteCtrl.controller 'RootCtrl', ['$scope', '$rootScope', ($scope, $rootScope) ->
  $rootScope.$broadcast('ROOT_CALLED');
]

@searchControllers = angular.module 'searchControllers', []

@searchControllers.controller 'searchCtrl', ['$scope', '$http', '$location', ($scope, $http, $location) ->
  $scope.get_current = (current_id, id) ->
    if current_id == id
      return 'active'
    else
      return ''
  $scope.$on 'ROOT_CALLED', (event, args) ->
    $http.get '/notes/latest'
      .success (data, status) ->
        $scope.searchText = ''
        $scope.results = data
        if data.length > 0
          $location.path("/note/view/#{data[0].id}")

  $scope.$on 'RELOAD_LATEST_NOTE', (event, args) ->
    $scope.current_id = args[0]
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

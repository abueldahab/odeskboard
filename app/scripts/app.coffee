config = ($routeProvider, $compileProvider) ->

  Parse.initialize "93VFmr6tOy5V9pAq394v4K1jUWPBPhmbK5wnl7de",
                   "ji3cu7JjrpTehN04iVOnOvM6nV4sKhHqzfLCO42F"

  $compileProvider.aHrefSanitizationWhitelist(/^\s*(https?|ftp|mailto|chrome-extension):/)
  $routeProvider.when "/",
    templateUrl: "views/main.html"
    controller: "MainCtrl"
    access: 'user'

  entities = {}
    #'Drink':['Add', '_Edit', 'List', '_View']
    #'Todo':[]
    #'Cash':[]
    #'Idea':['List']

  _.each entities, (pages, e)->
    le = e.toLowerCase()
    for p in pages
      # The underscore indicates path needs /:id appended
      id = if p[0] == '_' then '/:id'  else ''
      p = if p[0] == '_' then p.substring(1) else p
      lp = p.toLowerCase()
      $routeProvider.when "/#{le}/#{lp}#{id}",
        templateUrl: "views/#{le}/#{lp}.html"
        controller: "#{e}#{p}Ctrl"
        access: 'user'

  $routeProvider.when '/signin',
    templateUrl: 'views/signin.html',
    controller: 'SigninCtrl'
    access: 'public'

  $routeProvider.when '/signup',
    templateUrl: 'views/signup.html',
    controller: 'SignupCtrl'
    access: 'public'

  $routeProvider.otherwise redirectTo: '/'

dependencies = ['ui.bootstrap', 'ngRoute', 'dng.parse']
app = angular.module("odeskboardApp", dependencies).config config

rootController = (root, location)->

  root.go = (url)->
    location.path('/' + url)

  root.$on '$routeChangeStart', (event, next)->
    if next.access isnt 'public' and not root.user
      root.go 'signin'
  root.user = Parse.User.current()

app.run ['$rootScope', '$location', rootController]

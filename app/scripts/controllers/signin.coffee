controller = (scope)->
  if scope.user
    scope.go '/'
  
  scope.onSuccess = ->
    scope.go '/'

  scope.onError = (user, error)->
    scope.error = "Please, check your username and password."
    console.log scope.error

angular.module('odeskboardApp')
  .controller 'SigninCtrl',
    ['$scope', controller]

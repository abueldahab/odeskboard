controller = (location, scope, element, attrs) ->

angular.module('odeskboardApp')
  .directive 'navcontainer', ->
    templateUrl: "views/directives/nav.html"
    restrict: 'E'
    scope: true
    transclude: true
    replace: true
    controller: ['$location', '$scope', '$element', '$attrs', controller]

filter = () ->
  (input) ->
    if input then 'Yes' else 'No'

angular.module('odeskboardApp')
  .filter 'truthy', filter

filter = -> _.str.capitalize

angular.module('odeskboardApp')
  .filter 'capital', filter

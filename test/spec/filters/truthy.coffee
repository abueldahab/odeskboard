'use strict'

describe 'Filter: truthy', () ->

  # load the filter's module
  beforeEach module 'drinksApp'

  # initialize a new instance of the filter before each test
  truthy = {}
  beforeEach inject ($filter) ->
    truthy = $filter 'truthy'

  it 'should return the input prefixed with "truthy filter:"', () ->
    text = 'angularjs'
    expect(truthy text).toBe ('truthy filter: ' + text)

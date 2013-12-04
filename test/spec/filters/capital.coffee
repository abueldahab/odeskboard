'use strict'

describe 'Filter: capital', () ->

  # load the filter's module
  beforeEach module 'drinksApp'

  # initialize a new instance of the filter before each test
  capital = {}
  beforeEach inject ($filter) ->
    capital = $filter 'capital'

  it 'should return the input prefixed with "capital filter:"', () ->
    text = 'angularjs'
    expect(capital text).toBe ('capital filter: ' + text);

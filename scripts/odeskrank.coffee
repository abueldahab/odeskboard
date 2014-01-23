"use strict"
phantom = require "phantom"
_ = require 'lodash'
#url = 'https://www.odesk.com/o/profiles/browse/?q=angularjs&page=4'
jquery = "http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"
lodash = "//cdnjs.cloudflare.com/ajax/libs/lodash.js/2.4.1/lodash.js"

cycle = 40000


main = (page) ->

  onLoad = (callback)->
    ->
      # Runs inside the page context
      # Returns value, no callbacks
      getFreelancersNames = ->
        arr = []
        $("h2 span[itemprop='name']").each ->
          arr.push $(this).html()
        arr

      onError = (result) ->
        console.log result

      setTimeout ->
        ### Evaluate after ajax render
        ###
        names = page.evaluate(getFreelancersNames, onError)
        callback names
      , cycle

  getPagesCount = ->
    pagination = $('nav.oPagination')
    count = '0'
    if pagination
      count = pagination.first().find('li a').last().attr('href').split('page=')[1]
    parseInt count, 10

  # TODO: Make that variable from the search pages
  oDeskRun = (callback, keyword='angularjs', pagesLimit=2)->
    # First page will be 1 after ++
    pageIndex = 0
    allFreelancers = {}
    loopFn = ->
      if pageIndex++ > pagesLimit
        return

      currentIndex = pageIndex
      oDeskurl = "https://www.odesk.com/o/profiles/browse/?q=#{keyword}"
      if pageIndex > 1
        oDeskurl += "&page=#{pageIndex}"
      console.log oDeskurl

      singlePageCallback = (names)->
        if names
          for name, i in names
            rank = (i + 1) + (currentIndex * names.length)
            allFreelancers[name] = rank
            console.log "Adding #{name} with rank #{rank}"
        done()

      page.open oDeskurl, (status) ->
        page.injectJs jquery, onLoad(singlePageCallback)

    # First Get the count
    oDeskurl = "https://www.odesk.com/o/profiles/browse/?q=#{keyword}"
    page.open oDeskurl, (status) ->
      page.injectJs jquery, ->
        setTimeout ->
          count = getPagesCount()
          pagesLimit = count
          console.log "Going to search in #{count} pages."

          # then start looping
          #loopFn()
          #interval = setInterval loopFn, cycle
        , cycle

    done = _.after pagesLimit, ->
      clearInterval interval
      console.log allFreelancers
      callback allFreelancers

  find = (name, list)->
    for freelancer, rank of list
      if freelancer.indexOf(name) >= 0
        return rank
    return -1

  callback = (list)->
    rank = find 'Diaa', list
    console.log list
    console.log "You Are indexed : " + rank
  oDeskRun callback

# Phantom Context
phantom.create (ph)->
  ph.createPage main

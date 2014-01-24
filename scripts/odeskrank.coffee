phantom = require "phantom"
_ = require 'lodash'
#url = 'https://www.odesk.com/o/profiles/browse/?q=angularjs&page=4'
keyword = 'AngularJS'
pages = 20
cycle = 5000
jquery = "http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"
lodash = "//cdnjs.cloudflare.com/ajax/libs/lodash.js/2.4.1/lodash.min.js"

allFreelancers = {}

phantom.create (ph) ->

  atEnd = _.after pages, (all)->
    console.log all
    ph.exit()

  callback = (list, index)->
    if list
      console.log list
      for name, i in list
        allFreelancers[name] = index * (i+1)
      atEnd allFreelancers


  openLater = (url, index, callback)->
    ph.createPage (page) ->

      page.open url, (status) ->
        console.log "opened odesk? ", status

        onError = (result) ->
          callback(result, index)
                
        page.injectJs jquery, ->
          page.injectJs lodash, ->
            #jQuery Loaded.
            #Wait for a bit for AJAX content to load on the page.
            #Here, we are waiting 5 seconds.
            setTimeout (->
              js = ->
                h2Arr = []
                #Get what you want from the page using jQuery.
                #A good way is to populate an object with all the
                #jQuery commands that you need and then return the object.
                $("h2 span[itemprop='name']").each ->
                  h2Arr.push $(this).html()
                h2Arr

              console.log page.evaluate(js, onError)
            ), 8000

  open = (index, callback)->
    setTimeout ->
      url = "https://www.odesk.com/o/profiles/browse/?q=#{keyword}"
      if index > 1
        url = url + "&page=#{index}"
      console.log "Opening : #{url}"
      openLater url, index, callback
    , cycle * Math.random()

  for index in [1..pages]
    open index, callback

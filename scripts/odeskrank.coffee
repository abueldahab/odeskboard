phantom = require "phantom"
_ = require 'lodash'
#url = 'https://www.odesk.com/o/profiles/browse/?q=angularjs&page=4'
jquery = "http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"
lodash = "//cdnjs.cloudflare.com/ajax/libs/lodash.js/2.4.1/lodash.min.js"

pages = 400
cycle = 8000
#keyword = 'AngularJS'
#searchname = 'Diaa Kasem'
keyword = 'illustrator'
searchname = 'Nawal Magdy'

allFreelancers = {}

phantom.create (ph) ->

  atEnd = _.after pages, (all)->
    console.log "#{searchname} ranked #{all[searchname]} for #{keyword}"
    ph.exit()

  callback = (list, index)->
    #console.log list
    #console.log '=============='
    console.log '.'
    if list
      for name, i in list
        allFreelancers[name] = index * (i+1)
      atEnd allFreelancers


  openLater = (url, callback)->
    ph.createPage (page) ->

      page.open url, (status) ->
        #console.log "opened odesk? ", status

        onError = (result) ->
          callback(result)
                
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

              res = page.evaluate(js, onError)
              if res
                callback res
            ), cycle

  open = (index, callback)->
    url = "https://www.odesk.com/o/profiles/browse/?q=#{keyword}"
    if index > 1
      url = url + "&page=#{index}"
    openLater url, (list)->
      callback list, index
      if index < pages
        open ++index, callback

  open 1, callback

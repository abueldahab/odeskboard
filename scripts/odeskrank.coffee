phantom = require "phantom"
_ = require 'lodash'
#url = 'https://www.odesk.com/o/profiles/browse/?q=angularjs&page=4'
keyword = 'AngularJS'
page = 1
url = "https://www.odesk.com/o/profiles/browse/?q=#{keyword}&page=#{page}"
jquery = "http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"
lodash = "//cdnjs.cloudflare.com/ajax/libs/lodash.js/2.4.1/lodash.min.js"

allFreelancers = []

phantom.create (ph) ->
  ph.createPage (page) ->

    onError = (result) ->
      allFreelancers.concat result
      #ph.exit()

    for index in [1..5]

      url = "https://www.odesk.com/o/profiles/browse/?q=#{keyword}&page=#{index}"
      page.open url, (status) ->
        console.log "opened odesk? ", status
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

              allFreelancers.concat page.evaluate(js, onError)
            ), 2000


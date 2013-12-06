phantom = require "phantom"
#url = 'https://www.odesk.com/o/profiles/browse/?q=angularjs&page=4'
keyword = 'AngularJS'
page = 1
url = "https://www.odesk.com/o/profiles/browse/?q=#{keyword}&page=#{page}"
jquery = "http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"


phantom.create (ph) ->
  ph.createPage (page) ->
    page.open url, (status) ->
      console.log "opened odesk? ", status
      page.injectJs jquery, ->
        
        #jQuery Loaded.
        #Wait for a bit for AJAX content to load on the page. Here, we are waiting 5 seconds.
        setTimeout (->
          page.evaluate (->
            h2Arr = []
            
            #Get what you want from the page using jQuery. A good way is to populate an object with all the jQuery commands that you need and then return the object.
            $("h2 span[itemprop='name']").each ->
              h2Arr.push $(this).html()

            h2Arr
          ), (result) ->
            console.log result
            ph.exit()
        ), 5000




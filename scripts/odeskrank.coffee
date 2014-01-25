phantom = require "phantom"
_ = require 'lodash'
#url = 'https://www.odesk.com/o/profiles/browse/?q=angularjs&page=4'
jquery = "http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"
lodash = "//cdnjs.cloudflare.com/ajax/libs/lodash.js/2.4.1/lodash.min.js"

pages = 10000
cycle = 8000
#keyword = 'd3js'
#keyword = 'nodejs'
args = process.argv
if args.length < 4
  console.log 'Usage: coffee odeskrank.coffee <Display Name> <Search term>'
  process.exit(1)

inline = (msg)->
  process.stdout.write msg

log = (msg)->
  console.log msg


keyword = process.argv[3]
searchname = process.argv[2]

allFreelancers = {}
startTime = +new Date()
phantom.create (ph) ->

  atEnd = (all)->
    log "#{searchname} ranked #{all[searchname]} for #{keyword}"
    endTime = +new Date()
    time = Math.floor((endTime - startTime) / 1000)
    minutes = Math.floor(time / 60)
    seconds = time % 60
    log "Time taken : #{minutes} minutes #{seconds} seconds."
    ph.exit()

  callback = (list, index, url)->
    if list
      for name, i in list
        allFreelancers[name] = ( index * list.length ) + (i+1)
      if searchname in list
        log url
        atEnd allFreelancers
      else
        inline '.'


  openLater = (url, callback)->
    ph.createPage (page) ->

      page.open url, (status) ->

        onError = (result) ->
          callback(result)
          page.close()
                
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
                page.close()
            ), cycle

  open = (index, callback)->
    url = "https://www.odesk.com/o/profiles/browse/?q=#{keyword}"
    if index > 1
      url = url + "&page=#{index}"
    openLater url, (list)->
      callback list, index, url
      if index < pages
        open ++index, callback

  open 1, callback

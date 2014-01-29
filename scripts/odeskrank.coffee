jsdom = require "jsdom"

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

atEnd = (all)->
  log "#{searchname} ranked #{all[searchname]} for #{keyword}"
  endTime = +new Date()
  time = Math.floor((endTime - startTime) / 1000)
  minutes = Math.floor(time / 60)
  seconds = time % 60
  log "Time taken : #{minutes} minutes #{seconds} seconds."

jqueryify = (url, callback)->
  jsdom.env
    url:  url
    scripts: [
      "http://code.jquery.com/jquery-2.0.2.min.js",
      "//cdnjs.cloudflare.com/ajax/libs/lodash.js/2.4.1/lodash.min.js"
    ]
    done: callback

openLater = (url, callback)->
  jqueryify url, (err, window)->
    $ = window.$
    h2Arr = []
    $("h2 span[itemprop='name']").each ->
      h2Arr.push $(this).html()
    callback h2Arr

onSuccess = (index)->
  (list)->
    for name, i in list
      allFreelancers[name] = ((index - 1) * list.length ) + (i+1)

    if searchname in list
      atEnd allFreelancers
    else if ++index < pages
      inline "Scanning page #{index} \r"
      open(index)

open = (index)->
  url = "https://www.odesk.com/o/profiles/browse/?q=#{keyword}"
  if index > 1
    url = url + "&page=#{index}"
  openLater url, onSuccess(index)

open 1

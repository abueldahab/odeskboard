// Generated by CoffeeScript 1.6.3
(function() {
  var allFreelancers, cycle, jquery, keyword, lodash, pages, phantom, _;

  phantom = require("phantom");

  _ = require('lodash');

  keyword = 'AngularJS';

  pages = 20;

  cycle = 5000;

  jquery = "http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js";

  lodash = "//cdnjs.cloudflare.com/ajax/libs/lodash.js/2.4.1/lodash.min.js";

  allFreelancers = {};

  phantom.create(function(ph) {
    return ph.createPage(function(page) {
      var atEnd, baseUrl, callback, index, open, openLater, url, _i, _results;
      atEnd = _.after(pages, function(all) {
        console.log(all);
        return ph.exit();
      });
      callback = function(list, index) {
        var i, name, _i, _len;
        if (list) {
          console.log(list);
          for (i = _i = 0, _len = list.length; _i < _len; i = ++_i) {
            name = list[i];
            allFreelancers[name] = index * (i + 1);
          }
          return atEnd(allFreelancers);
        }
      };
      openLater = function(url, index, callback) {
        return page.open(url, function(status) {
          var onError;
          console.log("opened odesk? ", status);
          onError = function(result) {
            return typeof callback === "function" ? callback(result, index) : void 0;
          };
          return page.injectJs(jquery, function() {
            return page.injectJs(lodash, function() {
              return setTimeout((function() {
                var js;
                js = function() {
                  var h2Arr;
                  h2Arr = [];
                  $("h2 span[itemprop='name']").each(function() {
                    return h2Arr.push($(this).html());
                  });
                  return h2Arr;
                };
                return console.log(page.evaluate(js, onError));
              }), 8000);
            });
          });
        });
      };
      open = function(url, index, callback) {
        return setTimeout(function() {
          return openLater(url, index, callback);
        }, cycle * Math.random());
      };
      baseUrl = "https://www.odesk.com/o/profiles/browse/?q=" + keyword;
      open(baseUrl, 1, callback);
      _results = [];
      for (index = _i = 1; 1 <= pages ? _i <= pages : _i >= pages; index = 1 <= pages ? ++_i : --_i) {
        url = baseUrl + ("&page=" + index);
        console.log("Opening : " + url);
        _results.push(open(url, index, callback));
      }
      return _results;
    });
  });

}).call(this);

/*
//@ sourceMappingURL=odeskrank.map
*/

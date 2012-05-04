(function() {
  var Crawler, DoraScraper, Repository, exports,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Crawler = require("crawler").Crawler;

  Repository = require("./repository_model");

  DoraScraper = (function() {

    function DoraScraper() {
      this.processPage = __bind(this.processPage, this);      this.host = "https://github.com";
      this.url = "" + this.host + "/explore";
      this.list_selector = "ol.ranked-repositories";
      this.item_selector = "li";
      this.title_selector = "h3";
      this.description_selector = "p.description";
      this.scrape();
      return "Done.";
    }

    DoraScraper.prototype.scrape = function() {
      this.engine = new Crawler({
        maxConnections: 10,
        timeout: 60 * 1000,
        jQueryUrl: 'https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js',
        callback: this.processPage
      });
      return this.engine.queue([this.url]);
    };

    DoraScraper.prototype.processPage = function(error, result, $) {
      var elements,
        _this = this;
      elements = $("" + this.list_selector + " > " + this.item_selector + ":not(" + this.item_selector + ".last)");
      return elements.each(function(index, element) {
        var repository;
        element = $(element);
        repository = {
          name: $.trim(element.find(_this.title_selector).text()),
          url: _this.host + element.find(_this.title_selector).find('a').get(1).href,
          description: $.trim(element.find(_this.description_selector).text())
        };
        return Repository.update(repository, repository, {
          upsert: true
        }, function(err) {
          if (err) throw err;
          if (index === elements.length - 1) return process.exit();
        });
      });
    };

    return DoraScraper;

  })();

  module.exports = exports = DoraScraper;

}).call(this);

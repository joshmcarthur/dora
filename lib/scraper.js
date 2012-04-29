(function() {
  var Crawler, DoraScraper, Redis,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Crawler = require("crawler").Crawler;

  Redis = require("redis").createClient();

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
      var _this = this;
      return $("" + this.list_selector + " > " + this.item_selector + ":not(" + this.item_selector + ".last)").each(function(index, element) {
        var repository;
        element = $(element);
        repository = {};
        repository.name = $.trim(element.find(_this.title_selector).text());
        repository.url = element.find(_this.title_selector).find('a').get(1).href;
        repository.description = $.trim(element.find(_this.description_selector).text());
        repository.indexed_at = new Date();
        return Redis.hmset(repository.url, repository);
      });
    };

    return DoraScraper;

  })();

  new DoraScraper();

}).call(this);

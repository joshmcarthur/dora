Crawler = require("crawler").Crawler
Redis   = require("redis").createClient()

class DoraScraper
  constructor: ->
    @host = "https://github.com"
    @url = "#{@host}/explore"
    @list_selector = "ol.ranked-repositories"
    @item_selector = "li"
    @title_selector = "h3"
    @description_selector = "p.description"

    @scrape()

    return "Done."

  scrape: ->
    @engine = new Crawler(
      maxConnections: 10
      timeout: 60*1000
      jQueryUrl: 'https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js'
      callback: @processPage
    )

    @engine.queue [@url]


  processPage: (error, result, $) =>
    $("#{@list_selector} > #{@item_selector}:not(#{@item_selector}.last)").each (index, element) =>
      element = $(element)
      repository = {}
      repository.name = $.trim element.find(@title_selector).text()
      repository.url = element.find(@title_selector).find('a').get(1).href
      repository.description = $.trim element.find(@description_selector).text()
      repository.indexed_at = new Date()

      Redis.hmset(repository.url, repository)

new DoraScraper()

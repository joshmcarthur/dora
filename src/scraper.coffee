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
      repository = {
        name: $.trim element.find(@title_selector).text()
        url: @host + element.find(@title_selector).find('a').get(1).href
        description:  $.trim element.find(@description_selector).text()
        indexed_at: new Date()
      }

      console.log "Saving repository: #{JSON.stringify(repository)}"
      Redis.hmset(repository.name, repository)

    process.exit()

module.exports = exports = DoraScraper

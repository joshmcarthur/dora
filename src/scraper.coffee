Crawler = require("crawler").Crawler
Repository = require("./repository_model")

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
    elements = $("#{@list_selector} > #{@item_selector}:not(#{@item_selector}.last)")
    elements.each (index, element) =>
      element = $(element)
      github_name = $.trim(element.find(@title_selector).text()).split(' / ')
      repository = {
        name: github_name[1],
        user: github_name[0],
        url: (@host + element.find(@title_selector).find('a').get(1).href),
        description: $.trim(element.find(@description_selector).text()),
      }

      Repository.update repository, repository, {upsert: true}, (err) ->
        throw err if err
        process.exit() if (index == elements.length - 1)

module.exports = exports = DoraScraper

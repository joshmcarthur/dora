express = require 'express'
Repository = require '../lib/repository_model'

app = module.exports = express.createServer()


app.configure ->
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.static(__dirname + '/public')


app.configure 'development', ->
  app.use express.errorHandler({ dumpExceptions: true, showStack: true })

app.configure 'production', ->
  app.use express.errorHandler()

app.get '/', (req, resp) ->
  Repository.all (repos) ->
    resp.render 'index', {repositories: repos}

app.listen 3000
console.log "Express server listening on port %d in %s mode", app.address().port, app.settings.env

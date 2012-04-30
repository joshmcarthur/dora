MongoDbServer = require('mongodb').Server
MongoDb       = require('mongodb').Db

class Repository
  @create: (record) ->
    @initDbAndTables =>
      @collection.insert(record)

  @initDbAndTables: (callback) ->
    @mongodb_server = new MongoDbServer('localhost', 27017, auto_reconnect: true)
    @db = new MongoDb("dora", @mongodb_server, (err, db) =>
      @db = db
      @db.createCollection('repositories', (err, collection) =>
        @collection = collection
        callback()
      )
    )

  @all: (callback) ->
    @initDbAndTables =>
      @collection.find().toArray (err, items) ->
        callback(items)


module.exports = exports = Repository

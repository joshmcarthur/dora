(function() {
  var MongoDb, MongoDbServer, Repository, exports;

  MongoDbServer = require('mongodb').Server;

  MongoDb = require('mongodb').Db;

  Repository = (function() {

    function Repository() {}

    Repository.create = function(record) {
      var _this = this;
      return this.initDbAndTables(function() {
        return _this.collection.insert(record);
      });
    };

    Repository.initDbAndTables = function(callback) {
      var _this = this;
      this.mongodb_server = new MongoDbServer('localhost', 27017, {
        auto_reconnect: true
      });
      return this.db = new MongoDb("dora", this.mongodb_server, function(err, db) {
        _this.db = db;
        return _this.db.createCollection('repositories', function(err, collection) {
          _this.collection = collection;
          return callback();
        });
      });
    };

    Repository.all = function(callback) {
      var _this = this;
      return this.initDbAndTables(function() {
        return _this.collection.find().toArray(function(err, items) {
          return callback(items);
        });
      });
    };

    return Repository;

  })();

  module.exports = exports = Repository;

}).call(this);

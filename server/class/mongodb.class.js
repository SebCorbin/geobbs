(function() {
  var MongoDb;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  module.exports = MongoDb = (function() {
    function MongoDb(db, mongodb) {
      this.db = db;
      this.mongodb = mongodb;
      this.server = null;
      this.client = null;
      this.Models = {};
      this.BSON = this.mongodb.BSONPure;
    }
    MongoDb.prototype.init = function(onReady) {
      this.server = new this.mongodb.Server(this.db.ip, this.db.port, {});
      return new this.mongodb.Db(this.db.name, this.server, {}).open(__bind(function(error, client) {
        if (error) {
          throw error;
        }
        this.client = client;
        this.Models = require('../models')(this.mongodb, this.client);
        onReady();
        return this;
      }, this));
    };
    MongoDb.prototype.geoGet = function(params, cb) {
      return this.Models.CheckModel.geoGet(params, cb);
    };
    MongoDb.prototype.getUser = function(idUser, cb) {
      return this.Models.UserModel.getById(idUser, cb);
    };
    MongoDb.prototype.addCheck = function(User, loc, cb) {
      return this.Models.CheckModel.getCollection(__bind(function(collChecks) {
        var Check;
        Check = new this.Models.CheckModel(loc, User);
        Check.save(collChecks);
        return User.addCheck(Check, cb);
      }, this));
    };
    return MongoDb;
  })();
}).call(this);

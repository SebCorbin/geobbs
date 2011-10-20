(function() {
  module.exports = function(MongoDB, client) {
    var BSON, Check, _collChecks;
    BSON = MongoDB.BSONPure;
    _collChecks = null;
    return Check = (function() {
      /*
            _userId:
            loc:
            Check:{
              
            }
          */      function Check(loc, User, opt, _id) {
        var _base;
        this.loc = loc != null ? loc : {};
        this.opt = opt != null ? opt : {};
        this._id = _id != null ? _id : new BSON.ObjectID();
        this._userId = User && User._id ? User._id : new BSON.ObjectID();
        this.loc.lat = parseInt(this.loc.lat, 10) || -1;
        this.loc.lon = parseInt(this.loc.lon, 10) || -1;
        this.User = User.getGeneralInfo();
        (_base = this.opt).date || (_base.date = Date.now());
      }
      Check.prototype.save = function(CheckCollection) {
        return CheckCollection.save({
          _id: this._id,
          _userId: this._userId,
          loc: [this.loc.lat, this.loc.lon],
          Check: this.opt,
          User: this.User
        });
      };
      Check.getCollection = function(cb) {
        if (_collChecks) {
          return cb(_collChecks);
        }
        return client.collection('checks', function(err, coll) {
          if (err) {
            throw err;
          }
          _collChecks = coll;
          return cb(_collChecks);
        });
      };
      /*
          # @params params = lat, lon, count, distance
          # @params cb
          */
      Check.geoGet = function(opt, cb) {
        if (!opt.lat || !opt.lon) {
          return cb("Wrong geo");
        }
        if (opt.d) {
          opt.d = parseInt(opt.d, 10);
        }
        if (!opt.d || opt.d > 100) {
          opt.d = 100;
        }
        if (opt.c) {
          opt.c = parseInt(opt.c, 10);
        }
        if (!opt.c || opt.c > 100) {
          opt.c = 100;
        }
        return Check.getCollection(function(collChecks) {
          return collChecks.find({
            loc: {
              $near: [opt.lat, opt.lon],
              $maxDistance: opt.d
            }
          }, {}, {
            limit: opt.c
          }).toArray(cb);
        });
      };
      return Check;
    })();
  };
}).call(this);

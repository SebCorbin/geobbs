(function() {
  module.exports = function(MongoDB, client) {
    var BSON, Check, _collChecks;
    BSON = MongoDB.BSONPure;
    _collChecks = null;
    return Check = (function() {
      function Check(loc, User, _id, date) {
        this.loc = loc != null ? loc : {};
        this._id = _id != null ? _id : new BSON.ObjectID();
        this.date = date != null ? date : Date.now();
        this._userId = User && User._id ? User._id : new BSON.ObjectID();
        this.loc.lat = parseInt(this.loc.lat, 10) || -1;
        this.loc.lon = parseInt(this.loc.lon, 10) || -1;
      }
      Check.prototype.save = function(CheckCollection) {
        return CheckCollection.save({
          _id: this._id,
          _userId: this._userId,
          loc: [this.loc.lat, this.loc.lon],
          date: this.date
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
      return Check;
    })();
  };
}).call(this);

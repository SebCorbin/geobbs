(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  module.exports = function(MongoDB, client) {
    var BSON, User, _collUsers;
    BSON = MongoDB.BSONPure;
    _collUsers = null;
    return User = (function() {
      /*
          # Entity level
          */      function User(login, password, _id, checks) {
        this.login = login != null ? login : 'unknown';
        this.password = password != null ? password : '';
        this._id = _id != null ? _id : new BSON.ObjectID();
        this.checks = checks != null ? checks : [];
      }
      User.prototype.fromUser = function(User) {
        this._id = User._id;
        this.login = User.login;
        this.password = User.password;
        this.checks = User.checks;
        return this;
      };
      User.prototype.addCheck = function(Check, cb) {
        User.getCollection(__bind(function(collUsers) {
          console.log("Push de check:", this._id, Check._id);
          return collUsers.update({
            _id: this._id
          }, {
            '$push': {
              'checks': Check._id
            }
          }, {
            safe: true
          }, function(err) {
            if (err) {
              return cb(err);
            }
            return cb(true);
          });
        }, this));
        return this;
      };
      /*
          # Collection level
          */
      User.getById = function(idUser, cb) {
        if (String(idUser).length !== 24) {
          return cb(new Error("Wrong idUser format"));
        }
        return User.getCollection(__bind(function(collUsers) {
          return collUsers.findOne({
            _id: new client.bson_serializer.ObjectID(idUser)
          }, __bind(function(err, UserInNativeFormat) {
            if (err) {
              return cb(err);
            } else if (!UserInNativeFormat) {
              return cb(null, UserInNativeFormat);
            } else {
              return cb(null, new User().fromUser(UserInNativeFormat));
            }
          }, this));
        }, this));
      };
      User.getCollection = function(cb) {
        if (_collUsers) {
          return cb(_collUsers);
        }
        return client.collection('users', function(err, coll) {
          if (err) {
            throw err;
          }
          _collUsers = coll;
          return cb(_collUsers);
        });
      };
      return User;
    })();
  };
}).call(this);

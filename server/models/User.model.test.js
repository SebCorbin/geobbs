(function() {
  var UserFactory, a, common, testUser, _ref;
  _ref = require('../test/common.coffee'), a = _ref.a, common = _ref.common;
  UserFactory = require('./User.model');
  testUser = function(t, U, login, password, id, checks) {
    t.eql(U.login, login, "Login are identical");
    t.eql(U.password, password, "Password are identical");
    t.eql(U._id, id, "Id are identical");
    return t.eql(U.checks, checks, "Checks are identical");
  };
  module.exports = {
    'Should provide User': function(t) {
      t = a(t);
      t.isDefined(UserFactory);
      t.isDefined(UserFactory(common.mockFactory.MongoDB(), null));
      return t.done();
    },
    'Constructor should take 4 parameters': function(t) {
      var U, User;
      t = a(t);
      User = UserFactory(common.mockFactory.MongoDB(), null);
      U = new User(1, 2, 3, [4]);
      testUser(t, U, 1, 2, 3, [4]);
      return t.done();
    },
    'Should be able to import DB User Object': function(t) {
      var U, User;
      t = a(t);
      User = UserFactory(common.mockFactory.MongoDB(), null);
      U = new User();
      testUser(t, U, "unknown", "", {}, []);
      U.fromUser({
        _id: 10,
        login: "FG",
        password: "FG_",
        checks: [1, 2, 3]
      });
      testUser(t, U, "FG", "FG_", 10, [1, 2, 3]);
      return t.done();
    },
    'User.getById should throw an error for bad Ids': function(t) {
      var User;
      t = a(t);
      User = UserFactory(common.mockFactory.MongoDB(), null);
      t.throws(function() {
        return User.getById(120);
      }, Error);
      t.throws(function() {
        return User.getById("abc");
      }, Error);
      return t.done();
    },
    'User should be able to add a check': function(t) {
      var U, User, check, uid, uidCheck, _collUsers;
      t = a(t);
      t.expect(3);
      _collUsers = common.mockFactory.CollUserSimple();
      _collUsers.update = function(where, what, opt, cb) {
        t.eql(where, {
          _id: uid
        });
        t.eql(what, {
          '$push': {
            'checks': uidCheck
          }
        });
        return cb(true);
      };
      User = UserFactory(common.mockFactory.MongoDB(), null, {
        _collUsers: _collUsers
      });
      U = new User();
      check = common.mockFactory.DataCheck();
      uid = U._id = "4e7e0614bd99e29380000000";
      uidCheck = check._id = "4e1e0614bd99e29380000000";
      U.addCheck(check, function() {
        return t.ok(true);
      });
      return t.done();
    }
  };
}).call(this);

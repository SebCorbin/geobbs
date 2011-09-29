(function() {
  var sys;
  sys = require('sys');
  module.exports = {
    a: function(assert) {
      assert.eql = assert.deepEqual;
      assert.isNull = function(val, msg) {
        return assert.strictEqual(null, val, msg);
      };
      assert.isNotNull = function(val, msg) {
        return assert.notStrictEqual(null, val, msg);
      };
      assert.isUndefined = function(val, msg) {
        return assert.strictEqual(void 0, val, msg);
      };
      assert.isDefined = function(val, msg) {
        return assert.notStrictEqual(void 0, val, msg);
      };
      assert.type = function(obj, type, msg) {
        var real;
        real = typeof obj;
        msg = msg || "typeof " + sys.inspect(obj) + " is " + real + ", expected " + type;
        return assert.ok(type === real, msg);
      };
      assert.match = function(str, regexp, msg) {
        msg = msg || sys.inspect(str) + " does not match " + sys.inspect(regexp);
        return assert.ok(regexp.test(str), msg);
      };
      assert.includes = function(obj, val, msg) {
        msg = msg || sys.inspect(obj) + " does not include " + sys.inspect(val);
        return assert.ok(obj.indexOf(val) >= 0, msg);
      };
      assert.length = function(val, n, msg) {
        msg = msg || sys.inspect(val) + " has length of " + val.length + ", expected " + n;
        return assert.equal(n, val.length, msg);
      };
      return assert;
    },
    common: {
      mockFactory: {
        MongoDB: function() {
          return {
            BSONPure: {
              ObjectID: function() {
                return 1;
              }
            }
          };
        },
        Collection: function(saveFunc) {
          return {
            save: saveFunc || function() {}
          };
        },
        CollUserSimple: function() {
          return {};
        },
        DataUser: function() {
          return {
            _id: 1,
            login: "FG",
            password: "FG_",
            checks: []
          };
        },
        DataCheck: function() {
          return {
            _id: 190,
            _userId: 1,
            loc: [10, 11],
            date: Date.now()
          };
        }
      }
    }
  };
}).call(this);

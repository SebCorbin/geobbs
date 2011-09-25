(function() {
  var conf, _i, _len, _ref;
  module.exports = {};
  _ref = ['db', 'http'];
  for (_i = 0, _len = _ref.length; _i < _len; _i++) {
    conf = _ref[_i];
    module.exports[conf] = require("./" + conf);
  }
}).call(this);

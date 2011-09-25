(function() {
  var models;
  models = ['Check', 'User'];
  module.exports = function(MongoDB, client) {
    var m, o, _i, _len;
    o = {};
    for (_i = 0, _len = models.length; _i < _len; _i++) {
      m = models[_i];
      console.log("Loading " + m + ".model...");
      o["" + m + "Model"] = require("./" + m + ".model")(MongoDB, client);
    }
    return o;
  };
}).call(this);

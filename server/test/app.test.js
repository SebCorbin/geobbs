(function() {
  var app, assert;
  app = require("../app");
  assert = require("assert");
  module.exports = {
    "GET /": function() {
      return assert.response(app, {
        url: "/"
      }, {
        status: 200,
        headers: {
          "Content-Type": "text/html; charset=utf-8"
        }
      }, function(res) {
        return assert.includes(res.body, "<title>GeoBBS</title>");
      });
    }
  };
}).call(this);

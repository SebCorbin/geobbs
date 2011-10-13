(function() {
  var MongoDb, app, dbConfig, express, http, loadUser, mongodb, renderJSON, _ref;
  express = require("express");
  _ref = require('./config'), dbConfig = _ref.db, http = _ref.http;
  MongoDb = require('mongodb');
  mongodb = new (require('./class/mongodb.class'))(dbConfig, MongoDb);
  mongodb.init(function() {
    return console.log("Mongodb connected on " + dbConfig.ip + ":" + dbConfig.port);
  });
  app = module.exports = express.createServer();
  app.configure(function() {
    app.set("views", __dirname + "/views");
    app.set("view engine", "jade");
    app.use(express.bodyParser());
    app.use(express.methodOverride());
    app.use(app.router);
    return app.use(express.static(__dirname + "/public"));
  });
  app.configure("development", function() {
    return app.use(express.errorHandler({
      dumpExceptions: true,
      showStack: true
    }));
  });
  app.configure("production", function() {
    return app.use(express.errorHandler());
  });
  app.get("/", function(req, res) {
    return res.render("index", {
      title: "GeoBBS"
    });
  });
  loadUser = function(req, res, next) {
    return mongodb.getUser(req.params.userId, function(err, user) {
      console.log(user);
      req.user = user;
      return next();
    });
  };
  renderJSON = function(res, json) {
    return res.send(JSON.stringify(json), {
      'Content-Type': 'text/javascript'
    }, json.code);
  };
  /* 
    PRIVATE
  */
  app.all("/:userId/check/:lat,:lon", loadUser, function(req, res) {
    var out;
    out = {
      code: 404,
      type: 'error',
      msg: 'User not found'
    };
    if (!req.user) {
      return renderJSON(res, out);
    }
    return mongodb.addCheck(req.user, {
      lat: req.params.lat,
      lon: req.params.lon
    }, function(err, success) {
      if (err) {
        out.code = 500;
        out.type = 'error';
        out.msg = err || 'Something went wrong';
      } else {
        out.code = 200;
        out.type = 'success';
        out.msg = success || '';
      }
      return renderJSON(res, out);
    });
  });
  /*
    PUBLIC
  
    Retourne pour chaque item:
      User
      Geo
      Date du check
  
      /?lat=&lon=&c=&
  */
  app.get("/check/", function(req, res) {
    var out, q;
    q = req.query;
    out = {
      code: 500,
      type: 'error',
      msg: 'Missing parameters'
    };
    if (!q.lat || !q.lon) {
      return renderJSON(res, out);
    }
    return mongodb.geoGet(q, function(err, success) {
      out.code = 200;
      out.type = 'success';
      out.msg = success;
      return renderJSON(res, out);
    });
  });
  app.listen(http.port, "0.0.0.0");
  console.log("Express server listening on port %d", app.address().port);
}).call(this);

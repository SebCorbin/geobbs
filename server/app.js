(function() {
  var API_checks, MongoDb, app, dbConfig, express, http, loadUser, log, logger, mongodb, renderJSON, _ref;
  express = require("express");
  _ref = require('./config'), dbConfig = _ref.db, http = _ref.http;
  MongoDb = require('mongodb');
  log = require('util').log;
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
    return mongodb.getUser(req.query.userId, function(err, user) {
      req.user = user;
      return next();
    });
  };
  logger = function(req, res, next) {
    log(req.originalMethod + ' ' + req.originalUrl);
    return next();
  };
  renderJSON = function(res, json) {
    return res.send(JSON.stringify(json), {
      'Content-Type': 'text/javascript'
    }, json.code);
  };
  /* 
    POST
  
    /check/create/
  
    Params:
      - userId
      - lat
      - lon
      - [description]
      - [imgUrl]
  */
  app.all("/check/create/", [logger, loadUser], function(req, res) {
    var out;
    out = {
      code: 404,
      type: 'error',
      msg: 'User not found'
    };
    if (!req.user) {
      return renderJSON(res, out);
    }
    return mongodb.addCheck(req.user, req.query, function(err, success) {
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
    Retourne chaque item les plus proches
  
    GET
    
    /check/list
  
    Params:
      -userId
  */
  API_checks = function(req, res) {
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
  };
  app.get("/check/list", [logger, loadUser], API_checks);
  app.listen(http.port, "0.0.0.0");
  console.log("Express server listening on port %d", app.address().port);
}).call(this);

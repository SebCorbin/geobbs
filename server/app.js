(function() {
  var MongoDb, app, dbConfig, express, http, loadUser, mongodb, _ref;
  express = require("express");
  _ref = require('./config'), dbConfig = _ref.db, http = _ref.http;
  MongoDb = require('mongodb');
  mongodb = new (require('./class/mongodb.class'))(dbConfig, MongoDb);
  mongodb.init(function() {
    return console.log("Mongodb connected on " + db.ip + ":" + db.port);
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
      if (err) {
        return next(err);
      }
      if (!user) {
        return next(new Error("User " + req.params.userId + " not found"));
      }
      req.user = user;
      return next();
    });
  };
  app.all("/:userId/check/:lat,:lon", loadUser, function(req, res) {
    console.log(req.user);
    return mongodb.addCheck(req.user, {
      lat: req.params.lat,
      lon: req.params.lon
    }, function(r) {
      return res.send("Ajout du check:" + r);
    });
  });
  app.listen(http.port);
  console.log("Express server listening on port %d", app.address().port);
}).call(this);

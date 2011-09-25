express = require("express")

# Load the configuration
{db:db, http:http}  = require './config'

# Chargement des modèles de données
MongoDb = require('mongodb')

mongodb = new (require('./class/mongodb.class'))(db, MongoDb)

mongodb.init(() ->
  console.log "Mongodb connected on #{db.ip}:#{db.port}"
)

app = module.exports = express.createServer()

app.configure ->
  app.set "views", __dirname + "/views"
  app.set "view engine", "jade"
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router
  app.use express.static(__dirname + "/public")

app.configure "development", ->
  app.use express.errorHandler(
    dumpExceptions: true
    showStack: true
  )

app.configure "production", ->
  app.use express.errorHandler()

app.get "/", (req, res) ->
  res.render "index", title: "GeoBBS"

loadUser = (req, res, next) ->
  # Est-ce que l'user est présent en BDD ?
  mongodb.getUser(req.params.userId, (err, user) ->
    if err
      return next(err)
    
    if !user
      return next(new Error("User #{req.params.userId} not found"))
    
    req.user = user
    next()
  )


# Check et retourne la liste X des utilisateurs les plus proches à moins de 100ms
app.all "/:userId/check/:lat,:lon", loadUser, (req, res) ->
  console.log(req.user)
  
  mongodb.addCheck(req.user, {lat:req.params.lat, lon:req.params.lon}, (r) ->
    res.send("Ajout du check:" + r)
  )

app.listen http.port

console.log "Express server listening on port %d", app.address().port
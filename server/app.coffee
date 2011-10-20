express = require("express")

# Load the configuration
{db:dbConfig, http:http}  = require './config'

# Chargement des modèles de données
MongoDb = require('mongodb')

log = require('util').log

mongodb = new (require('./class/mongodb.class'))(dbConfig, MongoDb)

mongodb.init(() ->
  console.log "Mongodb connected on #{dbConfig.ip}:#{dbConfig.port}"
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
    console.log user
    req.user = user
    next()
  )

logger = (req, res, next) ->
  log(req.originalMethod + ' ' + req.originalUrl)
  next()

renderJSON = (res, json) ->
  res.send JSON.stringify(json), { 'Content-Type': 'text/javascript' }, json.code

### 
  POST

  /user/:userId/check/

  Params:
    - lat
    - lon
    - description
    - imgUrl
###
app.all "/user/:userId/check/", [logger, loadUser], (req, res) ->

  out = {
      code:404 # User Not found
      type:'error'
      msg:'User not found'
  }
  
  if(!req.user)
    return renderJSON(res, out)

  
  mongodb.addCheck(req.user, req.query, (err, success) ->

    if err
      out.code = 500 # Internal Server error
      out.type = 'error'
      out.msg = err || 'Something went wrong'
    else
      out.code = 200
      out.type = 'success'
      out.msg = success ||''
    
    renderJSON(res, out)
  )

###
  Retourne chaque item les plus proches
###
API_checks = (req, res) ->
  q = req.query

  out = {
      code:500
      type:'error'
      msg:'Missing parameters'
  }

  return renderJSON(res, out) if !q.lat || !q.lon

  mongodb.geoGet(q, (err, success) ->
    out.code = 200
    out.type = 'success'
    out.msg  = success
    renderJSON(res, out)
  )

app.get "/checks/", logger, API_checks
app.get "/user/\{userId\}/check/", logger, API_checks


app.listen http.port, "0.0.0.0"

console.log "Express server listening on port %d", app.address().port
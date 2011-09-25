# Liste des modeles à exporter
models = ['Check', 'User']

module.exports = (MongoDB, client) ->
  o = {}
  
  for m in models
    console.log "Loading #{m}.model..."
    o["#{m}Model"] = require("./#{m}.model")(MongoDB, client) 
  
  return o
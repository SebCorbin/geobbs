# Gestionnaire :
# - Des modèles
# - De la connexion avec la base de données
module.exports = class MongoDb
  constructor: (@db, @mongodb) ->
    @server = null
    @client = null

    # Models non chargé
    @Models = {}

    @BSON = @mongodb.BSONPure

  init: (onReady) ->
    @server = new @mongodb.Server(@db.ip, @db.port, {})
    new @mongodb.Db(@db.name, @server, {}).open((error, client)  =>
      if error then throw error

      @client = client

      # Chargement des modèles
      @Models = require('../models')(@mongodb, @client)

      onReady()

      return this
    )

  
  
  # Récupérer un utilisateur à partir de son id
  getUser: (idUser, cb) ->
    @Models.UserModel.getById(idUser, cb)
    
  # Ajoute un check pour l'utilisateur @User
  # et retourner l'objet Check
  addCheck: (User, loc, cb) ->
    

    @Models.CheckModel.getCollection((collChecks) =>
      # Créer un check à partir du model
      Check = new @Models.CheckModel(loc, User)

      # Enregistrer le check en BDD
      Check.save(collChecks)



      # Ajouter la référence du check dans l'User
      User.addCheck(Check, cb)
    )
    
    

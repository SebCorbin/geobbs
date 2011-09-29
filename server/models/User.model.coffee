module.exports = (MongoDB, client, opt = {}) ->
  BSON = MongoDB.BSONPure

  _collUsers = opt._collUsers or null

  return class User
    ###
    # Entity level
    ###

    # new User().fromNativeFormat(User )
    # new User(login, password, )
    constructor: (@login = 'unknown', @password = '', @_id = new BSON.ObjectID(), @checks = []) ->

    # @chainable
    fromUser: (User) ->
      # @TODO : extend()
      @_id = User._id
      @login = User.login
      @password = User.password
      @checks = User.checks

      @

    # Ajout un check à l'utilisateur
    # @chainable
    addCheck: (Check, cb)->
      User.getCollection((collUsers) =>

        console.log "Push de check:", @_id, Check._id
        collUsers.update({_id: @_id}, {'$push':{'checks':Check._id}}, {safe:true}, (err) ->
          if err
            return cb(err)
          
          cb(true)
        )
      )

      @
    
    ###
    # Collection level
    ###

    # Retourne un utilisateur par son id
    # cb(err, user)
    # user peut être null si non trouvé
    User.getById = (idUser, cb) ->
      return cb(new Error "Wrong idUser format") if String(idUser).length != 24

      User.getCollection((collUsers) =>

        collUsers.findOne({_id : new client.bson_serializer.ObjectID(idUser)}, (err, UserInNativeFormat) =>
          if err
            cb(err)
          else if !UserInNativeFormat
            cb(null, UserInNativeFormat)
          else
            cb(null, new User().fromUser(UserInNativeFormat))
        )
      )

    User.getCollection = (cb) ->
      return cb(_collUsers) if _collUsers

      client.collection('users', (err, coll) ->
        if err then throw err

        _collUsers = coll
        cb(_collUsers)
      )


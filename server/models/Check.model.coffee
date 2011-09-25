module.exports = (MongoDB, client) ->
  BSON = MongoDB.BSONPure

  _collChecks = null

  return class Check
    constructor: (@loc = {}, User, @_id = new BSON.ObjectID(), @date = Date.now) ->
      @_userId = if User && User._id then User._id else new BSON.ObjectID()

      @loc.lat = parseInt(@loc.lat, 10) || -1
      @loc.lon = parseInt(@loc.lon, 10) || -1

    save: (CheckCollection)->
      CheckCollection.save(
        _id   : @_id
        _userId : @_userId
        loc   : [@loc.lat, @loc.lon]
        date  : @date
      )
    
    
    # Collection
    Check.getCollection = (cb) ->
      return cb(_collChecks) if _collChecks

      client.collection('checks', (err, coll) ->
        if err then throw err

        _collChecks = coll
        cb(_collChecks)
      )

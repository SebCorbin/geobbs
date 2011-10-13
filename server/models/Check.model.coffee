module.exports = (MongoDB, client) ->
  BSON = MongoDB.BSONPure

  _collChecks = null

  return class Check
    ###
      _userId:
      loc:
      Check:{
        
      }
    ###
    constructor: (@loc = {}, User, @opt = {}, @_id = new BSON.ObjectID()) ->
      @_userId = if User && User._id then User._id else new BSON.ObjectID()

      @loc.lat = parseInt(@loc.lat, 10) || -1
      @loc.lon = parseInt(@loc.lon, 10) || -1

      @opt.date or= Date.now()

    save: (CheckCollection)->
      CheckCollection.save(
        _id   : @_id
        _userId : @_userId
        loc   : [@loc.lat, @loc.lon]
        Check : @opt
      )
    
    
    # Collection
    Check.getCollection = (cb) ->
      return cb(_collChecks) if _collChecks

      client.collection('checks', (err, coll) ->
        if err then throw err

        _collChecks = coll
        cb(_collChecks)
      )
    
    ###
    # @params params = lat, lon, count, distance
    # @params cb
    ###
    Check.geoGet = (opt, cb) ->

      if(!opt.lat || !opt.lon)
        return cb("Wrong geo")

      opt.d = parseInt(opt.d, 10) if opt.d

      if(!opt.d || opt.d > 100) # Max distance = 100
        opt.d = 100
      
      opt.c = parseInt(opt.c, 10) if opt.c
      if(!opt.c || opt.c > 100) # Max count = 100
        opt.c = 100

      Check.getCollection((collChecks) ->
        collChecks.find({ loc :{ $near : [opt.lat,opt.lon] , $maxDistance : opt.d} }, {} ,{limit:opt.c}).toArray(cb)
      )
















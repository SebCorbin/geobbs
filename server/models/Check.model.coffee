module.exports = (MongoDB, client) ->
  BSON = MongoDB.BSONPure

  _collChecks = null

  return class Check
    ###
      _userId:
      loc:
        0:(int)
        1:(int)
      date:(long)timestamp
      description:(string)
      User:
        [user]
    ###
    constructor: (@loc = {}, User, @opt = {}, @_id = new BSON.ObjectID()) ->
      @_userId = if User && User._id then User._id else new BSON.ObjectID()

      @loc.lat = parseInt(@loc.lat, 10) || -1
      @loc.lon = parseInt(@loc.lon, 10) || -1

      @User = User.getGeneralInfo()
      @opt.date or= Date.now()

    save: (CheckCollection)->
      CheckCollection.save(
        _id   : @_id
        _userId : @_userId
        loc   : [@loc.lat, @loc.lon]
        date  : @opt.date
        description : @opt.description
        User  : @User
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
        return cb("Wrong geo", null)

      opt.d = parseInt(opt.d, 10) if opt.d

      if(!opt.d || opt.d > 100) # Max distance = 100
        opt.d = 10000
      
      opt.c = parseInt(opt.c, 10) if opt.c
      if(!opt.c || opt.c > 100) # Max count = 100
        opt.c = 100
      
      Check.getCollection((collChecks) ->

        # Todo: Only get distinct userId by using map-reduce

        collChecks
          .find({
              loc :
                $near : [opt.lat,opt.lon] , 
                $maxDistance : opt.d
            }
            , {}
            , 
              limit:opt.c
            )
          .sort(date:-1)
          .toArray((err, success) ->
            # temporary work-around
            ids = {}

            cb(null, success.filter((el) ->

              if !ids[el._userId]
                ids[el._userId] = true
                return true
              else
                return false
            ))
          )
      )

















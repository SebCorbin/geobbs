{a, common} = require '../test/common.coffee'


CheckFactory = require './Check.model'

testCheck = (t, C, loc, User, _id, date) ->
  t.eql C.loc, {lat:parseInt(loc.lat, 10), lon:parseInt(loc.lon, 10)}, "Loc are identical"
  t.eql C._userId, User._id, "UserId are identical"
  t.eql C._id, _id, "Id are identical"
  t.eql C.date, date || Date.now()

module.exports = 
  'Should provide User': (t)->
    t = a(t)
    t.isDefined(CheckFactory)

    t.isDefined(CheckFactory(common.mockFactory.MongoDB(), null)) # User class
    t.done()
  
  'Constructor should take 4 parameters': (t) ->
    t = a(t)
    Check = CheckFactory(common.mockFactory.MongoDB(), null)

    d = Date.now()
    C =  new Check({lat:1,lon:2}, {_id:3}, 4, d)

    testCheck(t, C,{lat:1,lon:2}, {_id:3},4, d)

    t.done()
  
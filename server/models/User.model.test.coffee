{a, common} = require '../test/common.coffee'


UserFactory = require './User.model'

testUser = (t, U, login, password, id, checks) ->
  t.eql U.login, login, "Login are identical"
  t.eql U.password, password, "Password are identical"
  t.eql U._id, id, "Id are identical"
  t.eql U.checks, checks, "Checks are identical"

module.exports = 
  'Should provide User': (t)->
    t = a(t)
    t.isDefined(UserFactory)

    t.isDefined(UserFactory(common.mockFactory.MongoDB(), null)) # User class
    t.done()
  
  'Constructor should take 4 parameters': (t) ->
    t = a(t)
    User = UserFactory(common.mockFactory.MongoDB(), null)
    U =  new User(1,2,3,[4])

    testUser(t, U, 1,2,3,[4])

    t.done()

  'Should be able to import DB User Object': (t) ->
    t = a(t)
    User = UserFactory(common.mockFactory.MongoDB(), null)
    U =  new User()

    testUser(t, U, "unknown", "",{},  [])

    U.fromUser(
      _id:10
      login:"FG"
      password:"FG_"
      checks:[1,2,3]
    )

    testUser(t, U, "FG", "FG_", 10, [1, 2, 3])

    t.done()
  
  'User.getById should throw an error for bad Ids': (t) ->
    t = a(t)
    User = UserFactory(common.mockFactory.MongoDB(), null)

    t.throws () ->
      User.getById(120)
    , Error
    
    t.throws () ->
      User.getById("abc")
    , Error

    t.done()
  
  'User should be able to add a check': (t) ->
    t = a(t)
    t.expect(3)

    _collUsers = common.mockFactory.CollUserSimple()

    # @TODO: Add ::update in ColluserSimple() factory
    _collUsers.update = (where, what, opt, cb) ->
      t.eql where, {_id:uid}
      t.eql what, {'$push':{'checks':uidCheck}}

      cb(true)
    
    User = UserFactory(common.mockFactory.MongoDB(), null, {
      _collUsers: _collUsers
    })

    U =  new User()

    check = common.mockFactory.DataCheck()

    uid = U._id = "4e7e0614bd99e29380000000"
    uidCheck = check._id = "4e1e0614bd99e29380000000"
    
    U.addCheck(check, () ->
      t.ok true
    )

    t.done()


  
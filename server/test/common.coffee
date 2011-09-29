# Factory de mock & co
sys = require('sys')


module.exports =
  a: (assert) ->
      assert.eql = assert.deepEqual
      assert.isNull = (val, msg) ->
        assert.strictEqual null, val, msg

      assert.isNotNull = (val, msg) ->
        assert.notStrictEqual null, val, msg

      assert.isUndefined = (val, msg) ->
        assert.strictEqual undefined, val, msg

      assert.isDefined = (val, msg) ->
        assert.notStrictEqual undefined, val, msg

      assert.type = (obj, type, msg) ->
        real = typeof obj
        msg = msg or "typeof " + sys.inspect(obj) + " is " + real + ", expected " + type
        assert.ok type == real, msg

      assert.match = (str, regexp, msg) ->
        msg = msg or sys.inspect(str) + " does not match " + sys.inspect(regexp)
        assert.ok regexp.test(str), msg

      assert.includes = (obj, val, msg) ->
        msg = msg or sys.inspect(obj) + " does not include " + sys.inspect(val)
        assert.ok obj.indexOf(val) >= 0, msg

      assert.length = (val, n, msg) ->
        msg = msg or sys.inspect(val) + " has length of " + val.length + ", expected " + n
        assert.equal n, val.length, msg
      
        
      assert

  common:
    mockFactory:
      MongoDB:() ->
        return {
          BSONPure:
            ObjectID:() -> 1
        }
      
      Collection:(saveFunc) ->
        return {
          save: saveFunc or () ->
        }
      
      CollUserSimple:() ->
        return {}
      
      DataUser: () ->
        return {
          _id:1
          login:"FG"
          password:"FG_"
          checks:[]
        }
      
      DataCheck: () ->
        return {
          _id:190
          _userId:1
          loc:[10,11]
          date:Date.now()
        }
          

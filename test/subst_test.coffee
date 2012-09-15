{ ok, equal, deepEqual, strictEqual } = require 'assert'

subst = require '../lib/subst'


describe "subst", ->

  it "should substitute placeholders in string values", ->
    equal subst("hello world, hello there", { 'hello': 'goodbye' }), "goodbye world, goodbye there"

  it "should support keys with funny characters like $([{hello}])", ->
    equal subst("$([{hello}]) world", { '$([{hello}])': 'goodbye' }), "goodbye world"

  it "should substitute placeholders in array items", ->
    deepEqual subst(["one", "two", "three"], { 'e': 'o' }), ["ono", "two", "throo"]

  it "should splice substituted array items into the value array", ->
    deepEqual subst(["one", "two", "three"], { 'two': ['one point five', 'two point five'] }), ["one", "one point five", "two point five", "three"]

  it "should recurse into nested array items", ->
    deepEqual subst(["one", ["one point five", "two point five"], "three"], { 'e': 'o' }), ["ono", ["ono point fivo", "two point fivo"], "throo"]

  it "should substitute placeholders in object keys", ->
    deepEqual subst({"one": 1, "two": 2}, { 'e': 'o' }), {"ono": 1, "two": 2}

  it "should substitute placeholders in object values", ->
    deepEqual subst({"one": "hello", "two": "world"}, { 'hello': 'goodbye' }), {"one": "goodbye", "two": "world"}

  it "should recurse into nested objects", ->
    deepEqual subst({"one": 1, "two": { "two point three": 2.3, "two point seven": 2.7 }}, { 'e': 'o' }), {"ono": 1, "two": { "two point throo": 2.3, "two point sovon": 2.7 }}

  it "should pass through null values", ->
    strictEqual subst(null, { 'e': 'o' }), null

  it "should pass through undefined values", ->
    strictEqual subst(undefined, { 'e': 'o' }), undefined

  it "should pass through numeric values", ->
    strictEqual subst(42, { 'e': 'o' }), 42

  it "should pass through Date values", ->
    equal subst(new Date(1347738737148), { 'e': 'o' }).getTime(), 1347738737148

  it "should pass through custom objects", ->
    class Foo
    foo = new Foo()
    equal subst(foo, { 'e': 'o' }), foo


  describe ".wrap('{', '}')", ->
    s = subst.wrap('{', '}')
    it "should substitute placeholder '{foo}' with the value of key 'foo'", ->
      equal s("goodbye {foo} world", {'foo': 'cruel'}), "goodbye cruel world"

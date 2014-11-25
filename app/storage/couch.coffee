# Conexión a Couch.
# No sabe de frameworks como Backbone.
module.exports = class Couch

  # db connection object
  db: null
  # db host protocol
  protocol: 'http'
  # db host
  host: null
  # db port
  port: 5984
  # db name
  database: null

  constructor: (options) ->
    _.extend @, options
    @db = new PouchDB @protocol+'://'+@host+':'+@port+'/'+@database

  get: (id) ->
    result = Q.defer()
    @db.get id, (err, response) ->
      result.reject err if err
      result.resolve response if response
    result.promise

  queryView: (view, options) ->
    options.include_docs = true
    result = Q.defer()
    @db.query view, options, (err, response) ->
      result.reject err if err
      result.resolve response if response
    result.promise

  add: (doc) ->
    result = Q.defer()
    @db.post doc, (err, response) ->
      result.reject err if err
      result.resolve response if response
    result.promise

  remove: (doc) ->
    result = Q.defer()
    @db.remove doc, (err, response) ->
      result.reject err if err
      result.resolve response if response
    result.promise

  update: (doc) ->
    result = Q.defer()
    @db.put _.omit(doc, '_id'), doc._id, doc._rev, (err, response) ->
      result.reject err if err
      result.resolve response if response
    result.promise
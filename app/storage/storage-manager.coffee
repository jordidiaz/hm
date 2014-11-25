CouchStore = require './couch-store'

# Clase que maneja el almacenamiento e implementa Backbone.Sync.
# Acepta cualquier tipo de store que implemente la API.
# En este caso CouchStore la implementa.
module.exports = class StorageManager

  _.extend @prototype, Chaplin.EventBroker

  # storage object
  store: null

  constructor: (options) ->
    @store = new CouchStore options

    @subscribeEvent '!model:sync',      @_onModelSync
    @subscribeEvent '!collection:sync', @_onCollectionSync

  _onModelSync: (method, model, options) =>
    @_sync(method, model, options)

  _onCollectionSync: (method, collection, options) =>
    options.isCollection = true
    @_sync(method, collection, options)

  _sync: (method, model_or_collection, options) =>
    syncFn = @['_'+method]
    syncFn.call(@, model_or_collection, options)
    .then (result) ->
      options.success result
    .fail (err) =>
      alert 'error'
      if err.stack then console.log err.stack else console.log err
      # @publishEvent 'notify',
      #   message: err.status
      options.error err

  _read: (model_or_collection, options) ->
    if options.isCollection
      @store.getCollection(model_or_collection, options)
    else
      @store.get(model_or_collection)

  _create: (model) ->
    @store.add model

  _delete: (model) ->
    @store.remove model

  _update: (model) ->
    @store.update model
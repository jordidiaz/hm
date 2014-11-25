Couch = require './couch'

# Clase que implementa nuestra API hacia Couch.
# getDocument
# getCollection
# add
# remove
# update
# Parsea lo que devuelve Couch para no tener que sobrecargar el parse de Backbone
# Puente entre Backbone y Couch
module.exports = class CouchStore

  # couch object
  couch: null

  constructor: (options) ->
    @couch = new Couch options

  get: (model) ->
    @couch.get(model.id)

  getCollection: (collection, options) ->
    url = options.url or collection.url
    @couch.queryView(url, options)
    .then (response) ->
      _.map response.rows, (row) -> row.doc

  add: (model) ->
    @couch.add model.attributes
    .then (response) ->
      {
        _id: response.id
        _rev: response.rev
      }

  remove: (model) ->
    @couch.remove model.attributes
    .then (response) ->
      {
        _id: response.id
        _rev: response.rev
      }

  update: (model) ->
    @couch.update model.attributes
    .then (response) ->
      {
        _id: response.id
        _rev: response.rev
      }
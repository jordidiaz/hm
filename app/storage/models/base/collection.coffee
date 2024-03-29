Model = require './model'

module.exports = class Collection extends Chaplin.Collection
  # Use the project base model per default, not Chaplin.Model
  model: Model

  sync: (method, model, options) ->
    @publishEvent "!collection:sync", method, model, options

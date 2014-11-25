module.exports = class Model extends Chaplin.Model

  sync: (method, model, options) ->
    @publishEvent "!model:sync", method, model, options
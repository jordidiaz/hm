formatters = require './formatters'

module.exports = class DataBindingManager

  constructor: ->
    @_init()

  _init: ->
    # Configure Rivets
    rivets.configure
      prefix: 'hm'
    # Set up Rivets Backbone Adapter
    rivets.adapters[':'] =
      subscribe: (obj, keypath, callback) ->
        obj.on("change:#{keypath}", callback)
      unsubscribe: (obj, keypath, callback) ->
        obj.off("change:#{keypath}", callback)
      read: (obj, keypath) ->
        obj.get(keypath)
      publish: (obj, keypath, value) ->
        obj.set(keypath, value)
    # Add formatters
    _.extend rivets.formatters, formatters

  @bind: (el, binds, options) ->
    rivets.bind el, binds, options

  @unbind: (bindings) ->
    bindings.unbind()
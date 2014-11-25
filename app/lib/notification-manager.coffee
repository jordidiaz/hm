module.exports = class NotificationManager

  _.extend @prototype, Chaplin.EventBroker

  message: undefined

  constructor: ->
    @_subscribeEvents()

  _subscribeEvents: ->
    @subscribeEvent 'notify', @notify

  notify: (options) ->
    options = _.pick options, ['message']
    message = options.message || 'ups, no message no notify'
    alert message
AppView = require 'views/app-view'

module.exports = class AppController extends Chaplin.Controller

  index: ->
    @reuse 'site', AppView

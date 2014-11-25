View = require './view'
DataBindingManager = require 'lib/data-binding-manager'

module.exports = class CollectionView extends Chaplin.CollectionView
  # This class doesn’t inherit from the application-specific View class,
  # so we need to borrow the method from the View prototype:
  getTemplateFunction: View::getTemplateFunction

  # objeto que crea la libreria de bindings al crear los bindings
  bindings: null

  render: ->
    super
    @initBindings()

  dispose: ->
    @_destroyBindings()
    delete @bindings
    super

  initBindings: ->
    @bindings = DataBindingManager.bind @el, @

  _destroyBindings: ->
    DataBindingManager.unbind @bindings if @bindings

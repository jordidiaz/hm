DataBindingManager = require 'lib/data-binding-manager'

module.exports = class View extends Chaplin.View
  # Auto-save `template` option passed to any view as `@template`.
  optionNames: Chaplin.View::optionNames.concat ['template']

  autoRender: true

  modelSynced: false

  # objeto que crea la libreria de bindings al crear los bindings
  bindings: null

  # Precompiled templates function initializer.
  getTemplateFunction: ->
    @template

  render: ->
    super
    @initBindings()

  dispose: ->
    @_destroyBindings()
    delete @bindings
    super

  _whenModelSynced: ->
    deferred = Q.defer()
    if @modelSynced
      deferred.resolve true
    else
      @listenToOnce this, 'modelSynced', ->
        deferred.resolve true
    deferred.promise

  initBindings: ->
    @bindings = DataBindingManager.bind @el, @

  _destroyBindings: ->
    DataBindingManager.unbind @bindings if @bindings
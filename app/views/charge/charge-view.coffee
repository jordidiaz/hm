View     = require 'views/base/view'
template = require './templates/charge'

module.exports = class ChargeView extends View

  template: template

  editMode: false
  selected: false

  constructor: ->
    super
    @_modelEvents()

  _modelEvents: ->
    @listenTo @model, 'sync', @render

  selectCharge: =>
    return if @selected # TODO: da un error en la consola
    # Uncaught TypeError: Cannot read property 'find' of undefined
    if @editMode
      @_markSelected()
      @publishEvent 'chargeView:selected', @

  _markSelected: =>
    @selected = true
    return

  markUnselected: =>
    @selected = false
    return

  deleteCharge: =>
    @model.destroy()

  toggleMonthly: (e) =>
    e.stopPropagation()
    if @editMode
      @model.toggleMonthly()

  toggleEdit: ->
    @editMode = not @editMode
    @markUnselected()

  toEditMode: ->
    @editMode = true
    @$('.delete').removeClass('hidden')

  addToMonth: =>
    @publishEvent 'chargeView:addToMonth', @
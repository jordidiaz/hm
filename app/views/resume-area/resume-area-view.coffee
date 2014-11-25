View       = require 'views/base/view'
template   = require './templates/resume-area'
formatters = require 'lib/formatters'

module.exports = class ResumeAreaView extends View

  className: 'resume-area'
  template: template

  totalCharges: null
  totalDifference: null
  perWeek: null

  currencyFormatter: null

  resumeAvailable: false

  constructor: ->
    super
    @_collectionEvents()
    @_modelEvents()
    @currencyFormatter = formatters.currency.read

    @subscribeEvent 'monthManagerView:updateResume', @_onUpdateResume

  _onUpdateResume: (month) ->
    if month
      @resumeAvailable = true
      @model.set('_id', "$resume::#{month.get('_id')}")
      @model.fetch()
    else
      @resumeAvailable = false


  updateResumes: =>
    @_calculate()
    @_saveResume()

  _modelEvents: =>
    @listenTo @model, 'sync', @_onModelSynced

  _onModelSynced: (model) =>
    @_isModelSynced = true
    @trigger 'modelSynced'

  _calculate: =>
    # total gastos
    total = _.reduce @collection.models, ((memo, model) ->
      if not model.get('paid')
        memo + model.get('amount')
      else
        memo
    ), 0
    # total gastos
    @totalCharges = @currencyFormatter.call(@, total)
    # diferencia
    @totalDifference = @model.get('totalAccount') + @model.get('cash') - @totalCharges
    # por semana
    weeksLeft = @currencyFormatter(@, @model.get('weeksLeft'))
    if weeksLeft > 0
      @perWeek = @currencyFormatter.call(@, @totalDifference / weeksLeft)
    else
      @perWeek = @totalDifference

  _saveResume: =>
    @model.save()

  _collectionEvents: ->
    @listenTo @collection, 'sync', @_calculate
    @listenTo @collection, 'remove', @_calculate

  dispose: ->
    super
    delete @currencyFormatter
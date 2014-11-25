View             = require 'views/base/view'
template         = require './templates/month-manager'
MonthModel       = require 'storage/models/month'
MonthChargeModel = require 'storage/models/month-charge'
ResumeModel      = require 'storage/models/resume'
mediator         = require 'mediator'

module.exports = class MonthManagerView extends View

  className: 'month-manager'
  template: template

  date:
    month: undefined
    year: undefined

  # modelo que representa el month
  monthModel: undefined

  # indica si el mes seleccionado ya tiene gestión generada
  monthExists: false

  constructor: (options) ->
    super
    @_modelEvents()
    @subscribeEvent 'chargeView:addToMonth', @_onAddToMonth

  _onAddToMonth: (chargeView) =>
    return if not @monthModel
    monthCharge = new MonthChargeModel
      name: chargeView.model.get('name')
      amount: chargeView.model.get('amount')
      month_id: @monthModel.get('_id')
    if monthCharge.save()
      @collection.add monthCharge

  _modelEvents: =>
    @listenTo @model, 'sync', @_onModelSynced

  _onModelSynced: (model) =>
    if model.length is 1
      @monthModel = model.at(0)
      @monthExists = true
      @date.month = moment(@monthModel.get('datetime')).month()
      @date.year  = moment(@monthModel.get('datetime')).year()
      # ya que tenemos el mes pedimos los gastos de ese mes
      @_queryMonthCharges()
      @publishEvent 'monthManagerView:updateResume', model.at(0)
    else
      @monthExists = false
      @date.month = moment().month()
      @date.year  = moment().year()
      @collection.reset([])
      @publishEvent 'monthManagerView:updateResume'

    @_isModelSynced = true
    @trigger 'modelSynced'

  _queryMonthCharges: ->
    @collection.fetch
      key: @model.at(0).get('_id')
      url: 'monthCharges/by_month_id'

  onMonthChange: =>
    @date.month = parseInt(@$(".months").val())
    @date.year  = parseInt(@$(".years").val())
    datetime = moment().month(parseInt(@date.month)).year(parseInt(@date.year))
    @model.fetch
      startkey: datetime.startOf('month').toJSON()
      endkey: datetime.endOf('month').toJSON()
      limit: 1

  onLoadThisMonth: =>
    @_setThisMonth()
    datetime = moment()
    @model.fetch
      startkey: datetime.startOf('month').toJSON()
      endkey: datetime.endOf('month').toJSON()
      limit: 1

  onNewMonth: =>
    month = new MonthModel
      datetime: moment().month(parseInt(@$(".months").val())).year(parseInt(@$(".years").val())).startOf('month').toJSON()
    @listenTo month, 'sync', @_onMonthSynced
    month.save()

  _onMonthSynced: (monthModel) =>
    @monthModel = monthModel
    @monthExists = true
    monthlyCharges = mediator.charges.filter (charge) -> charge.get('monthly')

    _.each monthlyCharges, (charge) =>
      monthCharge = new MonthChargeModel
        name: charge.get('name')
        amount: charge.get('amount')
        month_id: monthModel.get('_id')
      if monthCharge.save()
        @collection.add monthCharge

    resume = new ResumeModel
      _id: "$resume::#{monthModel.get('_id')}"
      datetime: monthModel.get('datetime')
    @listenTo resume, 'sync', =>
      @publishEvent 'monthManagerView:updateResume', monthModel
    resume.save()

  getTemplateData: ->
    data = super
    data.months = moment.months()
    data

  render: ->
    @_whenModelSynced()
    .then =>
      super
      @_setThisMonth()

  _setThisMonth: ->
    @$(".months option[value=#{@date.month}]").attr('selected', true)
    @$(".years option[value=#{@date.year}]").attr('selected', true)

  dispose: ->
    delete @date
    delete @monthModel
    super
View        = require 'views/base/view'
ChargeModel = require 'storage/models/charge'
template    = require './templates/new-charge'

module.exports = class NewChargeView extends View

  className: 'new-charge'
  template: template

  # modo edición
  editMode: false

  # datos del charge por defecto
  defaultChargeData:
    name: ''
    amount: 0

  # datos del charge
  chargeData:
    name: null
    amount: null

  constructor: ->
    super
    @_subscribeEvents()
    _.extend @chargeData, @defaultChargeData

  _subscribeEvents: ->
    @subscribeEvent 'chargeView:selected',    @_prepareToEditCharge
    @subscribeEvent 'chargesView:toggleEdit', @_toggleEdit

  _prepareToEditCharge: (chargeView) =>
    return if not @editMode
    @model = chargeView.model
    _.extend @chargeData, _.pick @model.attributes, 'name', 'amount'

  _toggleEdit: =>
    @editMode = not @editMode
    _.extend @chargeData, @defaultChargeData

  saveCharge: =>
    charge = new ChargeModel @chargeData
    if charge.save()
      @publishEvent 'newChargeView:addCharge', charge

    _.extend @chargeData, @defaultChargeData

  editCharge: =>
    return unless @model
    _.extend @model.attributes, @chargeData
    @model.save()

  dispose: ->
    delete @chargeData
    delete @defaultChargeData
    super
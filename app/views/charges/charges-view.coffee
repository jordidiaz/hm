CollectionView = require 'views/base/collection-view'
template       = require './templates/charges'
ChargeView     = require 'views/charge/charge-view'

module.exports = class ChargesView extends CollectionView

  className: 'charges'
  itemView: ChargeView
  listSelector: '#charges-list'
  template: template

  editMode: false
  collectionFilled: false

  constructor: ->
    super
    @_subscribeEvents()
    @_collectionEvents()

  _collectionEvents: ->
    @listenTo @collection, 'remove', @_onRemoveFromCollection
    @listenTo @collection, 'sync',   @_onCollectionSync

  _subscribeEvents: ->
    @subscribeEvent 'chargeView:selected', @_selectCharge
    @subscribeEvent 'newChargeView:addCharge', @_onAddCharge

  _selectCharge: (chargeView) =>
    _.each @subviews, (charge) ->
      charge.markUnselected() if charge.cid isnt chargeView.cid

  _onAddCharge: (model) =>
    @collection.add model

  toggleEdit: =>
    @editMode = not @editMode
    @publishEvent 'chargesView:toggleEdit'
    _.each @subviews, (charge) ->
      charge.toggleEdit()

  _onRemoveFromCollection: =>
    @collectionFilled = @collection.length > 0
    @toggleEdit() if @collection.length is 0

  _onCollectionSync: =>
    @collectionFilled = @collection.length > 0
    if @editMode
      # ponemos todas las vistas de charge en modo edición
      _.each @subviews, (charge) ->
        charge.toEditMode()
CollectionView   = require 'views/base/collection-view'
template         = require './templates/month-charges'
MonthChargeView  = require 'views/month-charge/month-charge-view'

module.exports = class MonthChargesView extends CollectionView

  className: 'month-charges'
  itemView: MonthChargeView
  listSelector: '#month-charges-list'
  template: template

  chargesAvailable: false

  constructor: ->
    super
    @_collectionEvents()

  _collectionEvents: ->
    @listenTo @collection, 'sync',   @_onCollectionSync
    @listenTo @collection, 'reset',  @_onCollectionReset

  _onCollectionReset: =>
    if @collection.length is 0
      @chargesAvailable = false

  _onCollectionSync: =>
    @renderAllItems()
    @chargesAvailable = true

  dispose: ->
    super
    delete @chargesAvailable
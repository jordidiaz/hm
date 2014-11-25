View     = require 'views/base/view'
template = require './templates/edit-month-charge'

module.exports = class EditMonthChargeView extends View

  className: 'edit-month-charge'
  template: template
  region: 'editMonthCharge'

  action: null

  constructor: (options) ->
    super
    @_attachSpecialEvents()

  _attachSpecialEvents: ->
    @$('.edit-modal').on 'hide.bs.modal', (e) =>
      @trigger 'modalHide', @action

    @$('.edit-modal').on 'hidden.bs.modal', (e) =>
      @dispose()

  saveMonthCharge: =>
    @action = 'save'
    @$('.edit-modal').modal('hide')

  deleteMonthCharge: =>
    @action = 'delete'
    @$('.edit-modal').modal('hide')

  _removeSpecialEvents: ->
    @$('.edit-modal').off 'hide.bs.modal'
    @$('.edit-modal').off 'hidden.bs.modal'

  attach: ->
    super
    @$('.edit-modal').modal()

  dispose: ->
    @_removeSpecialEvents()
    super
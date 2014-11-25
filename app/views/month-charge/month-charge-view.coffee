View                = require 'views/base/view'
template            = require './templates/month-charge'
EditMonthChargeView = require './edit-month-charge-view'

module.exports = class MonthChargeView extends View

  template: template

  editMonthChargeView: null

  togglePaid: =>
    @model.togglePaid()

  showMonthChargeEdit: =>
    @editMonthChargeView = @subview 'edit-month-charge', new EditMonthChargeView model: @model
    @listenTo @editMonthChargeView, 'modalHide', @_onModalHide

  _onModalHide: (action) =>
    if action is 'delete'
      @deleteMonthCharge()
    else if action is 'save'
      @saveMonthCharge()

  deleteMonthCharge: =>
    @model.destroy()

  saveMonthCharge: =>
    @model.save()

  dispose: ->
    delete @editMonthChargeView
    super
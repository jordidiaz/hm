View     = require 'views/base/view'
template = require './templates/date'

module.exports = class DateView extends View

  className: 'date'
  template: template

  # fecha a mostrar
  date: null

  _.extend @prototype, Delayer

  constructor: ->
    @date = moment()
    @setInterval 'dateUpdate', 1000, @_onDateUpdate
    super

  _onDateUpdate: =>
    @date = moment()

  dispose: ->
    @clearInterval 'dateUpdate'
    delete @date
    super
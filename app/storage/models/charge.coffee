Model = require './base/model'

module.exports = class Charge extends Model

  defaults:
    name: ''
    amount: 0
    monthly: true
    type: 'charge'

  idAttribute: '_id'

  errors: undefined

  constructor: ->
    super
    @errors = []
    @on 'invalid', @_onModelInvalid

  validate: ->
    @errors = []
    if @get('name').length is 0
      @errors.push 'name mandatory'
    if @get('amount').length is 0
      @errors.push 'amount mandatory'
    if parseInt(@get('amount')) < 0
      @errors.push 'amount positive'

    # return
    if @errors.length > 0
      @errors
    else
      null

  toggleMonthly: ->
    @set('monthly', not @get('monthly'))
    @save()

  _onModelInvalid: =>
    @publishEvent 'notify',
      message: @validationError

Model = require './base/model'

module.exports = class MonthCharge extends Model

  defaults:
    name: ''
    amount: 0
    month_id: null
    paid: false
    type: 'monthCharge'

  idAttribute: '_id'

  togglePaid: ->
    @set('paid', not @get('paid'))
    @save()

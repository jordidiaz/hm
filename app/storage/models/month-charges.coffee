Collection  = require './base/collection'
MonthChargeModel = require './month-charge'

module.exports = class MonthCharges extends Collection

  url: 'monthCharges/all'
  model: MonthChargeModel
  comparator: 'name'

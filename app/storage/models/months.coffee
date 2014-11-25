Collection  = require './base/collection'
MonthModel = require './month'

module.exports = class Months extends Collection

  url: 'months/all'
  model: MonthModel
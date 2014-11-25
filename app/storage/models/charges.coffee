Collection  = require './base/collection'
ChargeModel = require './charge'

module.exports = class Charges extends Collection

  url: 'charges/all' # TODO: Dice demasiado de Couch, debería ser más dinámico.
  model: ChargeModel
  comparator: 'name'

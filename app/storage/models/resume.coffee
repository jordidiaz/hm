Model = require './base/model'

module.exports = class Resume extends Model

  defaults:
    type: 'resume'
    totalAccount: 0
    cash: 0
    weeksLeft: 1

  idAttribute: '_id'
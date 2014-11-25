Model = require './base/model'

module.exports = class Month extends Model

  defaults:
    type: 'month'
    datetime: ''

  idAttribute: '_id'
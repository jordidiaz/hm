StorageManager      = require './storage/storage-manager'
NotificationManager = require 'lib/notification-manager'
DataBindingManager  = require 'lib/data-binding-manager'
mediator            = require 'mediator'
Charges             = require './storage/models/charges'
MonthCharges        = require './storage/models/month-charges'
Months              = require './storage/models/months'
Resume              = require './storage/models/resume'
constants           = require './config/constants'

module.exports = class Application extends Chaplin.Application

  start: ->
    @_initLocale()
    @_initAppModules()
    @_fetchData()
    super

  _initLocale: ->
    moment.locale(navigator.language)

  _initAppModules: ->
    @_initStorageManager()
    @_initDataBinding()
    @_initNotificationManager()

  _initStorageManager: ->
    new StorageManager
      host: constants.storage.host
      database: constants.storage.database
      username: constants.storage.username
      password: constants.storage.password

  _initDataBinding: ->
    new DataBindingManager

  _initNotificationManager: ->
    new NotificationManager

  _fetchData: ->
    mediator.charges.fetch()

    mediator.months.fetch
      startkey: moment().startOf('month').toJSON()
      endkey: moment().endOf('month').toJSON()
      limit: 1
      success: (months, response, options) =>
        if months.length is 1
          monthId = months.at(0).get('_id')
          mediator.resume.set('_id', "$resume::#{monthId}")
          mediator.resume.fetch()

  initMediator: ->
    # gastos generales
    mediator.charges = new Charges
    # gastos de este mes
    mediator.monthCharges = new MonthCharges
    # mes actual
    mediator.months = new Months
    # resume actual
    mediator.resume = new Resume
    # Seal the mediator
    super

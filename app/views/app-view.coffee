View             = require 'views/base/view'
ChargesView      = require 'views/charges/charges-view'
NewChargeView    = require 'views/new-charge/new-charge-view'
DateView         = require 'views/date/date-view'
MonthManagerView = require 'views/month-manager/month-manager-view'
ChargeModel      = require 'storage/models/charge'
MonthChargesView = require 'views/month-charges/month-charges-view'
ResumeAreaView   = require 'views/resume-area/resume-area-view'
mediator         = require 'mediator'
appTemplate      = require './templates/app'

module.exports = class AppView extends View

  container: '#app-container'
  regions:
    monthCharges: '#month-charges-container'
    paidMonthCharges: '#paid-month-charges-container'
    newCharge: '#new-charge-container'
    charges: '#charges-container'
    date: '#date-container'
    monthManager: '#month-manager-container'
    resumeArea: '#resume-area-container'
    editMonthCharge: '#edit-month-charge-container'
  template: appTemplate

  constructor: ->
    super

    chargesView = new ChargesView region: 'charges', collection: mediator.charges
    @subview 'charges', chargesView

    newChargeView = new NewChargeView region: 'newCharge'
    @subview 'newCharge', newChargeView

    dateView = new DateView region: 'date'
    @subview 'date', dateView

    monthManagerView = new MonthManagerView model: mediator.months, collection: mediator.monthCharges, region: 'monthManager'
    @subview 'monthManager', monthManagerView

    monthChargesView = new MonthChargesView collection: mediator.monthCharges, region: 'monthCharges', filterer: (model) -> not model.get('paid')
    @subview 'monthCharges', monthChargesView

    paidMonthChargesView = new MonthChargesView collection: mediator.monthCharges, region: 'paidMonthCharges', filterer: (model) -> model.get('paid')
    @subview 'paidMonthCharges', paidMonthChargesView

    resumeAreaView = new ResumeAreaView model: mediator.resume, collection: mediator.monthCharges, region: 'resumeArea'
    @subview 'resumeArea', resumeAreaView

    # dev
    window.theView = @
    window.mediator = mediator

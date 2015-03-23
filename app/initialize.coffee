Application = require 'application'
routes      = require 'routes'

# Initialize the application on DOM ready event.
$ ->
    new Application {
      title: 'Homemoney',
      controllerSuffix: '-controller',
      routes,
      password: prompt ''
    }

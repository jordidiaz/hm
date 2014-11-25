formatters = {}

formatters.currency =
  read: (value) ->
    formatted = parseFloat(parseFloat(value).toFixed(2))
    if isNaN(formatted) then 0 else formatted
  publish: (value) ->
    parseFloat(parseFloat(value).toFixed(2))

formatters.date =
  read: (value) ->
    value.format("dddd, D MMMM YYYY, HH:mm:ss")
  publish: (value) ->
    value.format("dddd, D MMMM YYYY, HH:mm:ss")

module.exports = formatters

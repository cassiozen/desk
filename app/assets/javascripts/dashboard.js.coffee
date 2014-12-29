Section = require("Section")

class Dashboard extends Section
  constructor: (app) ->
    super "dashboard", app

  setup: ->
    super()

  activate: ->
    super()
    console.log("Dashboard")

  deactivate: ->
    super()

module.exports = Dashboard

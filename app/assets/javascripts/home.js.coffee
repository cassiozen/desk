Section = require("Section")

class Home extends Section
  constructor: (app) ->
    super "home", app, "/"

  setup: ->
    super()

  activate: ->
    super()
    console.log("Home")

  deactivate: ->
    super()

module.exports = Home

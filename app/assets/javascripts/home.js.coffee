Base = require("Base")
utils = require("utils")

class Home extends Base.ViewController
  constructor: ->
    super "home", "/"

  setup: ->
    super()

  activate: ->
    super()
    $("#heading").text utils.humanize(@name)
    @log("Home")

  deactivate: ->
    super()

module.exports = Home

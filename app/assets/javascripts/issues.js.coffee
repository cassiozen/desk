Base = require("Base")
utils = require("utils")

class Issues extends Base.ViewController
  constructor: ->
    super "issues", "/requests"

  setup: ->
    super()

  activate: ->
    super()
    @log("Issues")

  deactivate: ->
    super()

module.exports = Issues

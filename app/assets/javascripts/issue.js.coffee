Base = require("Base")
utils = require("utils")

class Issue extends Base.ViewController
  constructor: ->
    super "issue", "/requests/:issue"

  setup: ->
    super()

  activate: ->
    super()
    @log("Issue")

  deactivate: ->
    super()

module.exports = Issue

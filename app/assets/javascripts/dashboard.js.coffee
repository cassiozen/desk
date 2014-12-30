Base = require("Base")
utils = require("utils")

class Dashboard extends Base.ViewController
  elements:
    ".tiles-alizarin .tiles-body .text-center": "overdue"

  events:
    "click .tiles-alizarin": "click"

  constructor: ->
    super "dashboard"

  click: (event) ->
    @log("Clicked first box")
    @overdue.text(10)
    event.preventDefault()

  setup: ->
    super()

  activate: ->
    super()
    @log("Dashboard")

  deactivate: ->
    super()
    @log("deactivate")

module.exports = Dashboard

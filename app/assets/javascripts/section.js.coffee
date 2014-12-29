utils = require("utils");
class Section
  constructor: (element, @app, @pattern)->
    @el = ($ "#" + element)
    @name = element
    @pattern ?= "/#{element}"

  requireSetup: ()->
    return if @setupDone
    @setupDone = true
    @setup()

  setup: ()->
    console.log("Setup #{@name}")
    # Override

  #
  # Routing methods
  #
  activate: ->
    $("#heading").text utils.humanize(@name)
    @el.addClass "active"
    console.log("activating #{@name}")

  deactivate: ->
    @el.removeClass "active"
    console.log("deactivating #{@name}")

module.exports = Section
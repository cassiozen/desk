#= require jquery_ujs
#= require bootstrap
#= require bootstrap-wysiwyg
#= require jquery.uploadifive
#= require polyfills
#= require jquery.pjax

Home = require("Home")
Dashboard = require("Dashboard")
Issues = require("Issues")
Issue = require("Issue")
CreateIssue = require("CreateIssue")
routebeer = require('routebeer')

# Create sections
@sections = [
  new Home(@)
  new Dashboard(@)
  new Issues(@)
  new CreateIssue(@)
  new Issue(@)

]

# Start Pjax
$(document).pjax 'a', '[data-pjax-container]'

# Setup sections and routes

@routes = {routes:{}}

for section in @sections
  do (section) =>
    @routes.routes[section.name] = {
      pattern : section.pattern
      load    : ->
        section.requireSetup.bind(section)()
        section.activate.bind(section)()
      unload  : section.deactivate.bind(section)
    }

@routes["always"] = (route) -> console.log('We ran something')
@routes["notFound"] = (route) -> console.log('route not found')
@routes["event"] = 'pjax:end'

routebeer.init @routes
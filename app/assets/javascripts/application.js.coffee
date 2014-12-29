#= require jquery_ujs
#= require bootstrap
#= require polyfills
#= require jquery.pjax

Home = require("Home")
Dashboard = require("Dashboard")
routebeer = require('routebeer')

# Create sections
@sections = [
  new Home(@)
  new Dashboard(@)
]

# Start Pjax
$(document).pjax('a', '[data-pjax-container]')

# Setup sections and routes
@routes = {routes:{}}
for section in @sections
  section.requireSetup()
  @routes.routes[section.name] =
    pattern : section.pattern
    load    : section.activate.bind(section)
    unload  : section.deactivate.bind(section)

@routes["always"] = (route) -> console.log('We ran something')
@routes["notFound"] = (route) -> console.log('route not found')
@routes["event"] = 'pjax:end'

routebeer.init @routes
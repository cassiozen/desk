## Welcome to JeetFlow

People are overwhelmed with e-mail, and while there are lots of companies working on
better e-mail tools, the fundamental truth is that the amount of electronic communication
in our daily work won't diminish any time soon.

Jeet flow's purpose is to free people's inboxes by funneling repeating requests that
most professionals receive by e-mail to a specific tool where they can be organized,
monitored and delivered.

Jeet Flow was inspired by Issue tracker and help desk tools such as Jira, zendesk
(and even Github Issues), but tailored for the everyday non-technical user.

## Technical Aspects

Jeet Flow is build on Ruby on Rails. On the front-end it uses a combination of Pjax
along with a js router and a basic view-controller class (coffeescript). All views
are instantiated as the page loads, but the router activates and deactivates views
as necessary.

#### Multitenancy

Jeetflow has multi-tenant support based on subdomain. To test locally either configure
local vhosts (or use a tool such as POW). Another quick way to test is use an external
domain that points to 127.0.0.1 such as vcap.me (in e.g. subdomain.vcap.me:3000)



###
Base Structure
heavily based on Spine
###

Events =
  bind: (ev, callback) ->
    evs   = ev.split(' ')
    @_callbacks or= {} unless @hasOwnProperty('_callbacks')
    for name in evs
      @_callbacks[name] or= []
      @_callbacks[name].push(callback)
    this

  one: (ev, callback) ->
    @bind ev, handler = ->
      @unbind(ev, handler)
      callback.apply(this, arguments)

  trigger: (args...) ->
    ev   = args.shift()
    list = @_callbacks?[ev]
    return unless list
    for callback in list
      break if callback.apply(this, args) is false
    true

  listenTo: (obj, ev, callback) ->
    obj.bind(ev, callback)
    @listeningTo or= []
    @listeningTo.push {obj, ev, callback}
    this

  listenToOnce: (obj, ev, callback) ->
    listeningToOnce = @listeningToOnce or= []
    obj.bind ev, handler = ->
      idx = -1
      for lt, i in listeningToOnce when lt.obj is obj
        idx = i if lt.ev is ev and lt.callback is handler
      obj.unbind(ev, handler)
      listeningToOnce.splice(idx, 1) unless idx is -1
      callback.apply(this, arguments)
    listeningToOnce.push {obj, ev, callback: handler}
    this

  stopListening: (obj, events, callback) ->
    if arguments.length is 0
      for listeningTo in [@listeningTo, @listeningToOnce]
        continue unless listeningTo
        for lt in listeningTo
          lt.obj.unbind(lt.ev, lt.callback)
      @listeningTo = undefined
      @listeningToOnce = undefined

    else if obj
      for listeningTo in [@listeningTo, @listeningToOnce]
        continue unless listeningTo
        events = if events then events.split(' ') else [undefined]
        for ev in events
          for idx in [listeningTo.length-1..0]
            lt = listeningTo[idx]
            continue unless lt.obj is obj
            continue if callback and lt.callback isnt callback
            if (not ev) or (ev is lt.ev)
              lt.obj.unbind(lt.ev, lt.callback)
              listeningTo.splice(idx, 1) unless idx is -1
            else if ev
              evts = lt.ev.split(' ')
              if ev in evts
                evts = (e for e in evts when e isnt ev)
                lt.ev = $.trim(evts.join(' '))
                lt.obj.unbind(ev, lt.callback)
    this

  unbind: (ev, callback) ->
    if arguments.length is 0
      @_callbacks = {}
      return this
    return this unless ev
    evs = ev.split(' ')
    for name in evs
      list = @_callbacks?[name]
      continue unless list
      unless callback
        delete @_callbacks[name]
        continue
      for cb, i in list when (cb is callback)
        list = list.slice()
        list.splice(i, 1)
        @_callbacks[name] = list
        break
    this

Events.on  = Events.bind
Events.off = Events.unbind

Log =
  trace: true

  logPrefix: '(App)'

  log: (args...) ->
    return unless @trace
    if @logPrefix then args.unshift(@logPrefix)
    console?.log?(args...)
    this

moduleKeywords = ['included', 'extended']

class Module
  @include: (obj) ->
    throw new Error('include(obj) requires obj') unless obj
    for key, value of obj when key not in moduleKeywords
      @::[key] = value
    obj.included?.apply(this)
    this

  @extend: (obj) ->
    throw new Error('extend(obj) requires obj') unless obj
    for key, value of obj when key not in moduleKeywords
      @[key] = value
    obj.extended?.apply(this)
    this

  @proxy: (func) ->
    => func.apply(this, arguments)

  proxy: (func) ->
    => func.apply(this, arguments)

  constructor: ->
    @init?(arguments...)

class ViewController extends Module
  @include Events
  @include Log

  eventSplitter: /^(\S+)\s*(.*)$/

  constructor: (@element, @pattern)->
    @name = @element
    @pattern ?= "/#{@element}"

    @events = @constructor.events unless @events
    @elements = @constructor.elements unless @elements

    super()

  requireSetup: ()->
    return if @setupDone
    @setupDone = true
    @setup()

  setup: ()->
    context = @
    while parent_prototype = context.constructor.__super__
      @events = $.extend({}, parent_prototype.events, @events) if parent_prototype.events
      @elements = $.extend({}, parent_prototype.elements, @elements) if parent_prototype.elements
      context = parent_prototype

  activate: =>
    @el = ($ "#" + @element)
    @delegateEvents(@events) if @events
    @refreshElements() if @elements

  deactivate: =>
    @el.unbind()
    @unbind()
    @stopListening()

  $: (selector) -> $(selector, @el)

  delegateEvents: (events) ->
    for key, method of events

      if typeof(method) is 'function'
        # Always return true from event handlers
        method = do (method) => =>
          method.apply(this, arguments)
          true
      else
        unless @[method]
          throw new Error("#{method} doesn't exist")

        method = do (method) => =>
          @[method].apply(this, arguments)
          true

      match      = key.match(@eventSplitter)
      eventName  = match[1]
      selector   = match[2]

      if selector is ''
        @el.bind(eventName, method)
      else
        @el.on(eventName, selector, method)

  refreshElements: ->
    for key, value of @elements
      @[value] = @$(key)

  delay: (func, timeout) ->
    setTimeout(@proxy(func), timeout || 0)


createObject = Object.create or (o) ->
  Func = ->
  Func.prototype = o
  new Func()



# Globals

Base = @Base    = {}
module?.exports = Base

Base.Events     = Events
Base.Log        = Log
Base.Module     = Module
Base.ViewController = ViewController

# Global events

Module.extend.call(Base, Events)

# JavaScript compatability

Module.create = Module.sub =
  ViewController.create = ViewController.sub = (instances, statics) ->
      class Result extends this
      Result.include(instances) if instances
      Result.extend(statics) if statics
      Result.unbind?()
      Result
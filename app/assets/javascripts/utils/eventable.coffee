class Utils.Eventable
  events: null

  add_listener: (event_name, fn)->
    @add_listeners(event_name.split(' '), fn)

  inherit_listener: (object, event_name)->
    object.add_listener event_name, => @fire_event(event_name)

  add_listeners: (events_names, fn)->
    for event_name in events_names
      @_ensure_event(event_name)
      if @events[event_name].indexOf(fn) == -1
        @events[event_name].push fn

    fn

  remove_listener: (event_name, fn)->
    @remove_listeners(event_name.split(' '), fn)

  remove_listeners: (events_names, fn)->
    for event_name in events_names
      @_ensure_event(event_name)
      @events[event_name].splice @events[event_name].indexOf(fn), 1

  fire_event: (event_name, e1, e2, e3)->
    @_ensure_event(event_name)
    for fn in @events[event_name]
      fn(e1, e2, e3)

  delete_events: ->
    delete @events

  _ensure_event: (event_name)->
    @events = {} if !@events
    @events[event_name] = [] if !@events[event_name]
class MDC.Directions.Direction.Builder extends Utils.Eventable
  gmap: null

  walk_segments: null
  route_segments: null

  walk_distance: 0
  walk_distances: []
  route_distance: 0

  made_visible: false

  bus: null
  buses: null
  color: null
  buses_names: null
  bus_name: null

  route: null
  walk: null
  info_box: null

  visible: false

  constructor: (@walk_segments, @route_segments, @bus, @bus_route, @gmap)->
    #=== Totally not permanent, and should refactor in another class.
    @buses        = [@bus]
    @bus_routes   = [@bus_route]
    @buses_routes = [[@bus, @bus_route]]
    
    @color = @bus.color
    @buses_names = [@bus.data["name"]]

    @bus_name = @bus.data["name"]
    #=========================
    
    @build_route()
    @build_walk()
    @set_distances()
    @build_info_box()

  # A little optimization
  construct_for_visible: ->
    @made_visible = true
    @bind_elements()

  build_route: ->
    @route = new MDC.Directions.Direction.Route(@route_segments, @color, @gmap)

  build_walk: ->
    @walk = new MDC.Directions.Direction.Walk(@walk_segments, @buses, @gmap)

  set_distances: ->
    @walk_distance  = @walk.distance
    @walk_distances = @walk.distances
    @route_distance = @route.distance

  build_info_box: ->
    @info_box = new MDC.Directions.Direction.InfoBox(@walk_distances, @route_distance, @buses_names)

  bind_elements: ->
    @route.add_listener 'mouseover', =>
      @highlight()
      @fire_event 'mouseover'
      @fire_event 'route_mouseover'

    @route.add_listener 'mouseout', =>
      @unhighlight()
      @fire_event 'mouseout'
      @fire_event 'route_mouseout'

    @walk.add_listener 'mouseover', =>
      @highlight()
      @fire_event 'mouseover'
      @fire_event 'walk_mouseover'

    @walk.add_listener 'mouseout', =>
      @unhighlight()
      @fire_event 'mouseout'
      @fire_event 'walk_mouseout'

    @info_box.add_listener 'mouseover', =>
      @highlight()
      @fire_event 'mouseover'
      @fire_event 'info_box_mouseover'

    @info_box.add_listener 'mouseout', =>
      @unhighlight()
      @fire_event 'mouseout'
      @fire_event 'info_box_mouseout'

  show: ->
    if not @visible
      @construct_for_visible() if not @made_visible # A little optimization
#      @show_buses()
      @route.show()
      @walk.show()
      @info_box.show()
      @visible = true

  show_buses: ->
    state = {routes: 0, button: true}
    state[@bus_route.id] = 1
    @bus.set_state(state)

  hide: ->
    if @visible
#      @hide_buses()
      @route.hide()
      @walk.hide()
      @info_box.hide()
      @visible = false

  hide_buses: ->
    state = {routes: 0, button: false}
    @bus.set_state(state)

  highlight: ->
#    @shift_buses()
    @route.highlight()

  shift_buses: ->
    state = {popup: true}
    state[@bus_route.id] = 2
    @bus.shift_state state

  unhighlight: ->
#    @unshift_buses()
    @route.unhighlight()

  unshift_buses: ->
    @bus.unshift_state()

  append_info_box_to: (element)->
    @info_box.append_to element

  remove_info_box: ->
    @info_box.remove()

  destroy: ->
    @route.destroy()
    @walk.destroy()
    @info_box.destroy()
class window.Bus extends BusButton
  bus_group: null

  constructor: (data, bus_group)->
    @data = data
    @bus_group = bus_group

    @build_routes()
    @bind_routes_events()

    @build_info()

    super("bus-#{@data.id}")
    @bind_element_events()

  build_routes: ->
    @color           = ColorCycle.get()
    @departure_route = new BusRoute(@data.encoded_departure_route, this, true)
    @return_route    = new BusRoute(@data.encoded_return_route,    this, false)

  bind_routes_events: ->
    @departure_route.bind_event "mouseover", => @highlight()
    @departure_route.bind_event "mouseout", => @unhighlight()
    @return_route.bind_event "mouseover", => @highlight()
    @return_route.bind_event "mouseout", => @unhighlight()

  build_info: ->
    #@bus_info = new BusInfo(@data.id)

  bind_element_events: ->
    @element.removeAttr('title')

    @element.bind "click", (e)->
      e.preventDefault()

    @element.bind "mouseover", =>
      #@bus_info.hover_show()
      if @activated
        @departure_route.highlight()
        @return_route.highlight()

    @element.bind "mouseout", =>
      #@bus_info.hover_hide()
      if @activated
        @departure_route.unhighlight()
        @return_route.unhighlight()

  after_deactivate: ->
    #@bus_info.hide()
    @bus_group.deactivate()
    @departure_route.hide()
    @return_route.hide()

  after_activate: ->
    #@bus_info.show()
    @departure_route.show()
    @return_route.show()

  marker_image: ->
    BusesIcons.get(@data.id)
    
  paths_to_checkpoints: (checkpoints)->
    #departure_route_paths = @departure_route.paths_to_checkpoints(checkpoints)
    return return_route_paths    = @return_route.paths_to_checkpoints(checkpoints)

    if departure_route_paths.total_distance < return_route_paths.total_distance
      departure_route_paths
    else
      return_route_paths

  pass_through_circles: (circles)->
    departure_route_match = @departure_route.pass_through_circles(circles)
    return departure_route_match  if departure_route_match.matches()

    return_route_match = @return_route.pass_through_circles(circles)
    return return_route_match if return_route_match.matches()

    if departure_route_match.total_distance_left() < return_route_match.total_distance_left()
      departure_route_match
    else
      return_route_match

class window.Bus extends BusButton
  bus_group: null

  constructor: (data, bus_group)->
    @data = data
    @bus_group = bus_group

    @build_routes()
    @bind_routes_events()

    @build_popup()


    super("bus-#{@data.id}")
    @bind_element_events()

  build_routes: ->
    @color           = ColorCycle.get()
    @departure_route = new BusRoute(@data.encoded_departure_route, this, true)
    @return_route    = new BusRoute(@data.encoded_return_route,    this, false)

  bind_routes_events: ->
    @departure_route.add_listener "mouseover", => @on_route_hover(@departure_route)
    @departure_route.add_listener "mouseout", => @on_route_out(@departure_route)
    @return_route.add_listener "mouseover", => @on_route_hover(@return_route)
    @return_route.add_listener "mouseout", => @on_route_out(@return_route)

  on_route_hover: (route)->
    @highlight_routes(route)
    @highlight()
    @popup.show()

  on_route_out: (route)->
    @unhighlight_routes(route)
    @unhighlight()
    @popup.hide()

  on_button_over: ->
    if @activated
      @highlight_routes()

  on_button_out: ->
    if @activated
      @unhighlight_routes()

  # This onees are called from PathFinder.
  # TODO: I should refactor this or something into something less invasive.
  on_direction_over: (route)->
    @on_route_hover(route)

  on_direction_out: (route)->
    @on_route_out(route)

  build_popup: ->
    @popup = new BusPopup(@data.name)

  bind_element_events: ->
    @element.removeAttr('title')
    @element.bind "click", (e)->
      e.preventDefault()

    @element.bind "mouseover", => @on_button_over()
    @element.bind "mouseout", => @on_button_out()


  highlight_routes: (route)->
    if route # We assume is one of our routes...
      route.highlight()

    else
      @departure_route.highlight()
      @return_route.highlight()

  unhighlight_routes: (route)->
    if route # We assume is one of our routes...
      route.unhighlight()
    else
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
    
  direction_to_checkpoints: (checkpoints)->
    departure_route_direction = @departure_route.direction_to_checkpoints(checkpoints)
    return_route_direction    = @return_route.direction_to_checkpoints(checkpoints)

    if departure_route_direction.total_walking_distance < return_route_direction.total_walking_distance
      departure_route_direction
    else
      return_route_direction
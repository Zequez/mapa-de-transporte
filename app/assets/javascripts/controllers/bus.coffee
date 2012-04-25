class window.Bus extends BusButton
  bus_group: null

  constructor: (data, bus_group)->
    @data = data
    @bus_group = bus_group
    
    @direction = null
    @direction_visible = true

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

  on_direction_over: (route)->
    @on_route_hover(route)

  on_direction_out: (route)->
    @on_route_out(route)

  on_direction_interface_over: (route)->
    @highlight_routes(route)
    @highlight()

  on_direction_interface_out: (route)->
    @unhighlight_routes(route)
    @unhighlight()

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
    @bus_group.deactivate()
    @departure_route.hide()
    @return_route.hide()
    @direction.hide() if @direction

  after_activate: ->
    @departure_route.show()
    @return_route.show()
    @direction.show() if @direction and @direction_visible

  marker_image: ->
    BusesIcons.get(@data.id)
    
  direction_to_checkpoints: (checkpoints)->
    departure_route_direction = @departure_route.direction_to_checkpoints(checkpoints)
    return_route_direction    = @return_route.direction_to_checkpoints(checkpoints)

    if departure_route_direction.walking_distance < return_route_direction.walking_distance
      departure_route_direction
    else
      return_route_direction

  # Set from path_finder#handle_directions
  # TODO: I don't believe this is the best way to do this.
  set_direction: (direction)->
    if @direction != direction
      @direction = direction
      @bind_direction()
    @show_direction()

  show_direction: ->
    @direction_visible = true
    if @direction and @activated
      @direction.show()
      
  hide_direction: ->
    @direction_visible = false
    @direction.hide() if @direction
    
  remove_direction: ->
    @direction = null

  bind_direction: ->
    @direction.add_listener 'mouseover', =>
      @on_direction_over(@direction.route) if @direction
    @direction.add_listener 'interface_mouseover', =>
      @on_direction_interface_over(@direction.route) if @direction
    @direction.add_listener 'mouseout',  =>
      @on_direction_out(@direction.route) if @direction
    @direction.add_listener 'interface_mouseout',  =>
      @on_direction_interface_out(@direction.route) if @direction

      
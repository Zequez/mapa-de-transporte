# TODO: Treat routes as an array, don't differentiate between departure and return, just assign the colors.
# TODO: Make a directions handler to handle directions in a different class.

class MDC.Bus extends Utils.Eventable
  # Events
  # - activated
  # - deactivated

  activated: false

  constructor: (data, bus_group)->
    @data = data
    @bus_group = bus_group
    
    @direction = null
    @direction_visible = true

    @build_button()
    @build_routes()
    @build_popup()

    @bind_button()
    @bind_routes()

    @fire_initial_activation()

  ### Elements Builders ###
  #########################

  build_button: ->
    @button = new MDC.Interface.BusButton(@data["id"])

  build_routes: ->
    @color           = MDC.Helpers.Colors.get()
    @routes = []
    
    if @data["encoded_departure_route"]
      @routes.push new MDC.BusRoute(@data["encoded_departure_route"], this, true)

    if @data["encoded_return_route"]
      @routes.push new MDC.BusRoute(@data["encoded_return_route"],    this, false)
#    @departure_route =
#    @return_route    =


  ### Elements Events Binding ###
  ###############################

  build_popup: ->
    @popup = new MDC.Interface.BusPopup(@data["name"])

  bind_button: ->
    @button.add_listener 'activated', => @on_button_activate()
    @button.add_listener 'deactivated', => @on_button_deactivate()
    @button.add_listener 'mouseover', => @on_button_over()
    @button.add_listener 'mouseout', => @on_button_out()

  bind_routes: ->
    for route in @routes
      do (route)=>
        route.add_listener "mouseover", => @on_route_hover(route)
        route.add_listener "mouseout", => @on_route_out(route)
        
  ### Interface Elements Events Handlers ###
  ##########################################

  on_route_hover: (route)->
    @highlight_routes(route)
    @button.highlight()
    @popup.show()

  on_route_out: (route)->
    @unhighlight_routes(route)
    @button.unhighlight()
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
    @button.highlight()

  on_direction_interface_out: (route)->
    @unhighlight_routes(route)
    @button.unhighlight()

  on_button_activate: ->
    @show()

  on_button_deactivate: ->
    @hide()
  
  show: ->
    if not @activated
      @activated = true
      @button.activate()
      @show_routes()
      @direction.show() if @direction and @direction_visible
      @fire_event('activated')

  hide: ->
    if @activated
      @activated = false
      @button.deactivate()
      @bus_group.deactivate()
      @hide_routes()
      @direction.hide() if @direction
      @fire_event('deactivated')

  ### Some helpers functions ###
  ##############################

  fire_initial_activation: ->
    if @button.activated
      @show()

  highlight_routes: (route)->
    if route # We assume is one of our routes...
      route.highlight()
    else
      route.highlight() for route in @routes

  unhighlight_routes: (route)->
    if route # We assume is one of our routes...
      route.unhighlight()
    else
      route.unhighlight() for route in @routes

  show_routes: -> route.show() for route in @routes
  hide_routes: -> route.hide() for route in @routes

  marker_image: ->
    MDC.Helpers.BusesIcons.get(@data["id"])

  ### Direction stuff ###
  #######################

  direction_to_checkpoints: (checkpoints)->
    directions = []
    for route in @routes
      direction = route.direction_to_checkpoints(checkpoints)
      directions.push direction if direction


    ordered_directions = directions.sort (r1, r2)->
      r1.walking_distance > r2.walking_distance
      
    ordered_directions[0]

  # Set from path_finder#handle_directions
  set_direction: (direction)->
    if @direction != direction
      @direction = direction
      @bind_direction()
    @show_direction()

  # TODO: Should rename to something more intuitive, like "Don't show direction" or "direction_visible".
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

      
# TODO: Treat routes as an array, don't differentiate between departure and return, just assign the colors.
# TODO: Make a directions handler to handle directions in a different class.

# Events
# - button_activated
# - button_deactivated
# - button_hover
# - button_out
# - route_hover
# - route_out

class MDC.Buses.Bus extends Utils.Eventable
  # Events
  # - activated
  # - deactivated

  activated: false
  data: null


  constructor: (@data, @bus_group, @gmap)->
    @state = {}
    @hard_state  = {}
    @shifted_state = {}
    @current_state = {}

    @build_button()
    @build_routes()
    @build_popup()

    @bind_button()
    @bind_routes()

    @build_state_handler()
    @build_initial_state()


  build_initial_state: ->
    state = {}
    state.button  = @button.activated
    state.popup   = false
    state.highlight_ui = false


    # 0 - hidden
    # 1 - transparent
    # 2 - normal
    # 3 - highlighted
    state.routes = if @button.activated then 2 else 0

    @set_state(state)

  build_state_handler: ->
    @state_handler = {}

    @state_handler.button = (bool)=>
      return @button.activate()   if bool
      return @button.deactivate() if !bool

    @state_handler.popup = (bool)=>
      return @popup.show() if bool
      return @popup.hide() if !bool

    @state_handler.highlight_ui = (bool)=>
      return @button.highlight() if bool
      return @button.unhighlight() if !bool

    for route in @routes
      do (route)=>
        @state_handler[route.id] = (mode)=>
          route.set_mode(mode)

  # hard_state    does not get changed by shifted states
  # shited_state  exists only then there is a shifted state
  # state         changes always, and has the ultimate word

  shift_state: (new_state)->
    @shifted_state = @parse_state(new_state)
    @apply_state(@shifted_state, true)

  unshift_state: ->
    @shifted_state = false
    @apply_state @state

  set_state: (new_state)->
    @apply_state(@parse_state(new_state))


  parse_state: (new_state)->
    # If the state is set to #routes, then set the same state to both routes.
    if new_state.routes != undefined
      new_state = _.clone new_state
      for route in @routes
        new_state[route.id] ||= new_state.routes
      delete new_state.routes

    new_state

  apply_state: (new_state, shifted = false)->
    for i, value of new_state
      if @current_state[i] != value
        @state[i] = value if not shifted
        @apply_state_value i, value

  apply_state_value: (i, value)->
    @current_state[i] = value
    @state_handler[i](value) if @state_handler[i]


  ### Data gathering ###
  ######################

  is_activated: ->
    @button.activated

  perm: ->
    @data["perm"]


  ### Elements Builders ###
  #########################

  build_button: ->
    @button = new MDC.Buses.BusButton(@data["id"])

  build_routes: ->
    @color           = MDC.Helpers.Colors.get()
    @routes = []
    
    if @data["encoded_departure_route"]
      @routes.push new MDC.Buses.Route.Builder(@data["encoded_departure_route"], this, true, @gmap)

    if @data["encoded_return_route"]
      @routes.push new MDC.Buses.Route.Builder(@data["encoded_return_route"],    this, false, @gmap)
#    @departure_route =
#    @return_route    =


  ### Elements Events Binding ###
  ###############################

  build_popup: ->
    @popup = new MDC.Buses.BusPopup(@data["perm"])

  bind_button: ->
    @button.add_listener 'activated',   => @fire_event("button_activated")
    @button.add_listener 'deactivated', => @fire_event("button_deactivated")

    @button.add_listener 'mouseover',   => @fire_event("button_hover")
    @button.add_listener 'mouseout',    => @fire_event("button_out")

  bind_routes: ->
    for route in @routes
      do (route)=>
        route.add_listener "mouseover", => @fire_event("route_hover", route)
        route.add_listener "mouseout",  => @fire_event("route_out")

        

  ### Direction stuff ###
  #######################

  find_closest_route: (checkpoints)->
    directions = []
    for route in @routes
      direction = route.direction_to_checkpoints(checkpoints)
      directions.push direction if direction


    ordered_directions = directions.sort (r1, r2)->
      r1.walk_distance > r2.walk_distance

    ordered_directions[0]
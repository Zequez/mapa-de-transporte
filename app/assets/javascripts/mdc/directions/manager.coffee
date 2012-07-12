class MDC.Directions.Manager
  constructor: (@city, @buses_manager, @url_helper)->
    @gmap = @city.gmap
    @directions  = []
    @shown_directions  = []
    @hidden_directions  = []
    @binded_directions  = []

    @create_checkpoints_manager()
    @bind_checkpoints_manager()

    @create_controls()
    
    @bind_settings()

    @create_directions_listing()

    @checkpoints_manager.initial_check()

  create_checkpoints_manager: ->
    @checkpoints_manager = new MDC.Directions.Checkpoints.Manager(@city, [], @url_helper)

  bind_checkpoints_manager: ->
    @checkpoints_manager.add_listener 'change', (checkpoints)=>
      @checkpoints = checkpoints
      @calculate_buses()

  create_controls: ->
    @controls = new MDC.Directions.Controls.Builder()

  bind_settings: ->
    MDC.SETTINGS.add_listener 'change_max_walking_distance', =>
      @calculate_visible_directions() if @directions.length > 0

  create_directions_listing: ->
    @directions_listing = new MDC.Directions.DirectionsListing

  calculate_buses: ->
    @remove_directions()

    if @checkpoints.length > 0
      unsorted_directions = @buses_manager.find_closest_route @checkpoints

      @directions = unsorted_directions.sort (direction_a, direction_b)->
        direction_a.walk_distance - direction_b.walk_distance

      @directions_listing.set_directions @directions

      @calculate_visible_directions()
    else
      @directions_listing.set_state(-1)


  calculate_visible_directions: ->
    @shown_directions = []
    @hidden_directions = []

    max_distance = MDC.SETTINGS.read["max_walking_distance"]

    for direction in @directions
      if direction.walk_distance <= max_distance
        direction.show()
#        direction.bus.highlight direction.bus_route
        @shown_directions.push direction
      else
        direction.hide()
        @hidden_directions.push direction

    @directions_listing.set_state @shown_directions.length
    @bind_shown_directions()
    @set_buses_state()
    @bind_shown_directions()


  bind_shown_directions: ->
    for direction in @shown_directions
      if @binded_directions.indexOf(direction) == -1
        @bind_direction(direction)
    null

  bind_direction: (direction)->
    direction.add_listener "mouseover", =>
      @buses_manager.shift_state(direction.buses_routes, "direction_hover")

    direction.add_listener "mouseout", =>
      @buses_manager.unshift_state(direction.buses)
      
    @binded_directions.push direction

  set_buses_state: ->
    shown_buses   = []
    hidden_buses  = []
    
    for direction in @shown_directions
      shown_buses   = shown_buses.concat direction.buses_routes

    for direction in @hidden_directions
      hidden_buses  = hidden_buses.concat  direction.buses
      
    @buses_manager.set_state(hidden_buses, "direction_deactivated")
    @buses_manager.set_state(shown_buses, "direction_activated")


  remove_directions: ->
    for direction in @directions
      direction.destroy()
#      direction.route_bus.remove_direction()
#      direction.remove()
      
    @directions = []
    @shown_directions = []
    @hidden_directions = []
    @binded_directions = []

  
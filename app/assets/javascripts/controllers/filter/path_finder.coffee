class window.PathFinder
  constructor: (map, buses)->
    @map     = map
    @buses   = buses

    @checkpoints = []
    @buses_paths = []

    @create_checkpoints_manager()
    @bind_checkpoints_manager()
#    @create_filter_interface()
#    @create_bus_paths_interface()

#  create_bus_directions_interface: ->
#    @bus_directions_interface = new BusDirectionsInterface

#  create_filter_interface: ->
#    @filter_interface = new PathFilterInterface
#    @filter_instructions = new PathFilterInstructions


  create_checkpoints_manager: ->
    @checkpoints_manager = new CheckpointsManager(@map)

  bind_checkpoints_manager: ->
    @checkpoints_manager.add_listener 'checkpoint_added checkpoint_removed checkpoint_changed', =>
      @calculate_buses()

    @checkpoints_manager.add_listener 'checkpoint_direction_mouseover', (checkpoint_direction)=>
      checkpoint_direction.route_bus.on_direction_over checkpoint_direction.route

    @checkpoints_manager.add_listener 'checkpoint_direction_mouseout', (checkpoint_direction)=>
      checkpoint_direction.route_bus.on_direction_out checkpoint_direction.route

  calculate_buses: ->
    if @checkpoints_manager.count() > 0
      routes_directions = []
      
      for bus in @buses
        route_direction = bus.direction_to_checkpoints(@checkpoints_manager.checkpoints)
        routes_directions.push route_direction

      ordered_buses_directions = routes_directions.sort (bus_direction_a, bus_direction_b)->
        bus_direction_a.total_walking_distance - bus_direction_b.total_walking_distance

      routes_directions_to_display = ordered_buses_directions[0..(Settings.max_buses_suggestions-1)]
      routes_directions_to_hide    = ordered_buses_directions[Settings.max_buses_suggestions..]

      @handle_directions routes_directions_to_display, routes_directions_to_hide


  handle_directions: (to_display, to_hide)->
    for direction in to_display
      direction.route_bus.activate()
      @checkpoints_manager.set_directions direction.checkpoints_directions()

    for direction in to_hide
      direction.route_bus.deactivate()

    

  
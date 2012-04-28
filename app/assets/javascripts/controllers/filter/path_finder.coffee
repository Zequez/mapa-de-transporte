class window.PathFinder
  constructor: (map, buses)->
    @map     = map
    @buses   = buses

    @directions  = []
    @shown_directions  = []
    @hidden_directions  = []

    @create_checkpoints_manager()
    @bind_checkpoints_manager()

    @create_directions_interface()
    @bind_directions_interface()
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

  create_directions_interface: ->
    @directions_interface = new DirectionsInterface

  bind_directions_interface: ->
    @directions_interface.add_listener 'options_updated', =>
      @handle_directions()

  calculate_buses: ->
    @remove_directions()
    
    if @checkpoints_manager.count() > 0
      routes_directions = []
      
      for bus in @buses
        route_direction = bus.direction_to_checkpoints(@checkpoints_manager.checkpoints)
        routes_directions.push route_direction

      @directions = routes_directions.sort (bus_direction_a, bus_direction_b)->
        bus_direction_a.walking_distance - bus_direction_b.walking_distance

      @handle_directions()
    else
      @update_directions_interface()


  handle_directions: ->
    @shown_directions  = to_display  = @directions[0..(SETTINGS.read.max_routes_suggestions-1)]
    @hidden_directions = to_not_display  = @directions[SETTINGS.read.max_routes_suggestions..]
    
    for direction in @hidden_directions
      direction.route_bus.deactivate()
      direction.route_bus.hide_direction()

    for direction in @shown_directions
      direction.route_bus.activate()
      direction.route_bus.set_direction(direction)

    @update_directions_interface()

  remove_directions: ->
    for direction in @directions
      direction.route_bus.remove_direction()
      direction.remove()
      
    @directions = []
    @shown_directions = []
    @hidden_directions = []
    
  update_directions_interface: ->
    @directions_interface.set_directions @shown_directions, @directions.length

    

  
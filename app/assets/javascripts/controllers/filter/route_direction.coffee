class window.RouteDirection extends Eventable
  # Events
  # - mouseover
  # - mouseout
  # - interface_mouseover
  # - interface_mouseout

  walking_distance: 0
  route_distance: 0
  real_walking_distance: 0
  real_route_distance: 0
  ready_to_display: false

  constructor: (route, paths)->
    @route = route
    @route_bus = route.bus
    @map = route.map
    @paths = paths
    @directions = []

    @calculate_walking_distance()

  calculate_walking_distance: ->
    @walking_distance = 0
    for segment in @paths
      @walking_distance += segment.distance

  # We actually never need this, yet.
  calculate_route_distance: ->
    @route_distance = 0

  checkpoints_directions: ->
    return @directions if @directions
    @create_checkpoints_directions()

  create_checkpoints_directions: ->
    if @directions.length == 0
      @directions = []
      for path in @paths
        @directions.push new CheckpointDirection(path, @route)
      @bind_checkpoints_directions()
      @directions


  bind_checkpoints_directions: ->
    for direction in @directions
      direction.add_listener 'mouseover', => @fire_event('mouseover')
      direction.add_listener 'mouseout', =>  @fire_event('mouseout')

  remove: ->
    direction.remove() for direction in @directions
    @delete_events()

  show: ->
    if not @ready_to_display
      @prepare_for_displaying() # Because I'm going to be displayed in an interface element soon.
    direction.show() for direction in @directions

  hide: ->
    direction.hide() for direction in @directions

  prepare_for_displaying: ->
    @create_checkpoints_directions()
    @calculate_real_walking_distance()
    @set_bus_name()
    @ready_to_display = true

  calculate_real_walking_distance: ->
    @real_walking_distance = 0
    
    for segment in @paths
      @real_walking_distance += segment.distance_in_meters()

    @real_walking_distance = parseInt(@real_walking_distance)
      

  set_bus_name: ->
    @bus_name = @route_bus.data.name

  # Called from DirectionsInterface
  set_interface_element: (element)->
    @interface_element = element
    @bind_interface_element()

  bind_interface_element: ->
    @interface_element.add_listener 'mouseover', => @fire_event('interface_mouseover')
    @interface_element.add_listener 'mouseout', => @fire_event('interface_mouseout')
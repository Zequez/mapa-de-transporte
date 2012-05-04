# TODO: This class should be able to create the interface element on his own.

class MDC.Directions.RouteDirection extends Utils.Eventable
  # Events
  # - mouseover
  # - mouseout
  # - interface_mouseover
  # - interface_mouseout

  walking_distance: 0
  route_distance: 0
  real_walking_distance: 0
  real_route_distance: 0

  # A lot of things don't get calculated unless we are
  # going to display the RouteDirection in the map.
  ready_to_display: false

  constructor: (route, walking_segments, route_segments)->
    @route = route
    @route_bus = route.bus
    @map = route.map
    @walking_segments = walking_segments
    @route_segments = route_segments
    @directions = []

    @calculate_walking_distance()
    @calculate_real_walking_distance()

  calculate_walking_distance: ->
    @walking_distance = 0
    for segment in @walking_segments
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
      for path in @walking_segments
        @directions.push new MDC.Directions.CheckpointDirection(path, @route)
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
    @calculate_real_route_distance()
    @set_bus_name()
    @ready_to_display = true

  calculate_real_walking_distance: ->
    @real_walking_distance = 0
    
    for segment in @walking_segments
      @real_walking_distance += segment.distance_in_meters()

    @real_walking_distance = parseInt(@real_walking_distance)

  calculate_real_route_distance: ->
    @real_route_distance = 0

    for segment in @route_segments
      @real_route_distance += segment.distance_in_meters()

    @real_route_distance = parseInt(@real_route_distance)

  set_bus_name: ->
    @bus_name = @route_bus.data.name

  # Called from DirectionsInterface
  set_interface_element: (element)->
    @interface_element = element
    @bind_interface_element()

  bind_interface_element: ->
    @interface_element.add_listener 'mouseover', => @fire_event('interface_mouseover')
    @interface_element.add_listener 'mouseout', => @fire_event('interface_mouseout')
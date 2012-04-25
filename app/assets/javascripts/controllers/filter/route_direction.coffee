class window.RouteDirection extends Eventable
  constructor: (route, paths)->
    @route = route
    @route_bus = route.bus
    @map = route.map
    @paths = paths
    @total_walking_distance = 0
    @total_route_distance   = 0
    @directions = []

    @calculate_total_walking_distance()

  calculate_total_walking_distance: ->
    for segment in @paths
      @total_walking_distance += segment.distance

  calculate_total_route_distance: ->
    @total_route_distance = 5640

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
      direction.add_listener 'mouseout', => @fire_event('mouseout')

  remove: ->
    direction.remove() for direction in @directions
    @delete_events()

  show: ->
    @create_checkpoints_directions()
    direction.show() for direction in @directions

  hide: ->
    direction.hide() for direction in @directions
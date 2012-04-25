class window.RouteDirection
  constructor: (route, paths)->
    @route = route
    @route_bus = route.bus
    @map = route.map
    @paths = paths
    @total_walking_distance = 0
    @total_route_distance   = 0
    @_checkpoints_directions = null

    @calculate_total_walking_distance()

  calculate_total_walking_distance: ->
    for segment in @paths
      @total_walking_distance += segment.distance

  calculate_total_route_distance: ->
    @total_route_distance = 5640

  checkpoints_directions: ->
    return @_checkpoints_directions if @_checkpoints_directions
    @create_checkpoints_directions()

  create_checkpoints_directions: (map)->
    @_checkpoints_directions = []
    for path in @paths
      @_checkpoints_directions.push new CheckpointDirection(path, @route)
    @_checkpoints_directions

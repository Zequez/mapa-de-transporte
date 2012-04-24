class window.BusRouteMatch
  bus: null

  constructor: (shortest_paths, bus)->
    @bus = bus
    @paths = shortest_paths

    @calculate_total_distance()

  calculate_total_distance: ->
    @total_distance = 0
    for segment in @paths
      @total_distance += segment.distance
class window.BusRouteMatch
  bus: null

  constructor: (distances_left, bus)->
    @bus = bus
    @distances_left = distances_left

  matches: ->
    return @_matches if @_matches
    @_matches = true

    for distance in @distances_left
      if distance > 0
        return @_matches = false
    @_matches


  total_distance_left: ->
    return @_total_distance_left if @_total_distance_left
    @_total_distance_left = 0
    for distance in @distances_left
      @_total_distance_left += distance
    @_total_distance_left

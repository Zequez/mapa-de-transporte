class window.RoutePointMatch
  constructor: (target_point, point, index, route_point)->
    @target_point = target_point
    @point = point
    @index = index
    @route_point = route_point

  distance: (target_point = @target_point)->
    Math.sqrt @pseudo_distance(target_point)

  real_distance: ->
    @point_latlng        ||= new google.maps.LatLng(@point[0], @point[1])
    @target_point_latlng ||= new google.maps.LatLng(@target_point[0], @target_point[1])
    google.maps.geometry.spherical.computeDistanceBetween(@point_latlng, @target_point_latlng)

  pseudo_distance: (target_point = @target_point)->
    x = @point[0]-target_point[0]
    y = @point[1]-target_point[1]

    (x*x + y*y)
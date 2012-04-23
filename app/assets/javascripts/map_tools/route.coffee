class window.Route
  constructor: (map, coordinates, options)->
    @m = @map = map
    @gmap = @m.gmap
    @g = google.maps
    @ev = @g.event
    @coordinates = coordinates
    @options = options
    @process_points()
    @build_polyline()

  build_polyline: ->
    @poly = new @g.Polyline @polyline_options()

  process_points: ->
    if @coordinates[0] and @coordinates[0].constructor == Array
      @points = new @g.MVCArray([])
      for c in @coordinates
        @points.push new @g.LatLng c[0], c[1]
    else
      @points = new @g.MVCArray(@coordinates)
      new_coordinates = []
      for point in @coordinates
        new_coordinates.push [point.lat(), point.lng()]
      @coordinates = new_coordinates

  update_poly_path: (points = null)->
    if points
      @points = new @g.MVCArray(points)
    @poly.setPath @points

  polyline_options: ->
    _.extend {
      map: @gmap,
      path: @points,
#      checkpoints_accuracy: 0.001 # 0.0011548447338897202 # Aproximately 1 block
    }, @options

  update_options: (options)->
    @options = _.extend @options, options
    @options.visible = @poly.getVisible()
    @poly.setOptions @polyline_options()

  show: ->
    @poly.setVisible(true)

  hide: ->
    @poly.setVisible(false)

#  checkpoints: ->
#    return _checkpoints if _checkpoints
#    _checkpoints = []
#
#    coordinates.length
#    if length > 1
#      length -= 2
#      for i in [0..length]
#        point_from = coordinates[i]
#        point_to   = coordinates[i+1]
#
#        x1 = point_from.lat()
#        y1 = point_from.lng()
#        x2 = point_to.lat()
#        y2 = point_to.lng()
#
#
#    else
#      _checkpoints = coordinates
#
#    _checkpoints
      


#class window.RouteDirections
#  constructor: (route)->
#    @route = route
#    @gmap  = route.poly.getMap()
#    @g     = google.maps
#
#    @service = new @g.DirectionsService
#
#  update: (callback = ->)->
#    @callback = callback
#    @service.route @build_request(), (result, status)=>
#      console.log result, status
#      if status == "OK"
#        @render(result)
#        @callback() if callback == @callback
#
#
#  # Private
#
#  build_request: ->
#    points = @route.points.getArray()
#    waypoints = []
#    for point in points[1..-1]
#      waypoints.push {location: point}#new @g.DirectionsWaypoint(point)
#
#    {
#      destination: _.last(points),
#      origin: _.first(points),
#      waypoints: waypoints,
#      travelMode: @g.TravelMode.DRIVING
#    }
#
#  render: (result)->
#    if not @renderer
#      @renderer = new @g.DirectionsRenderer({
#        directions: result,
#        draggable: false,
#        map: @gmap,
#        preserveViewport: true
#      })
#    else
#      @renderer.setDirections result




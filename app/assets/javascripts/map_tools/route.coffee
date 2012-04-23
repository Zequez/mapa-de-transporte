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
    @build_segments()

  build_polyline: ->
    @poly = new @g.Polyline @polyline_options()

  build_segments: ->
    @segments = []
    length = @coordinates.length
    if length > 1
      length -= 2
      for i in [0..length]
        @segments.push new Segment(@coordinates[i], @coordinates[i+1], @points[i], @points[i+1])
      

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

class window.Segment
  constructor: (p1, p2, latlng1, latlng2)->
    @p1 = p1
    @p2 = p2
    @latlng1 = latlng1
    @latlng2 = latlng2
    @calculate_vars()

  calculate_vars: ->
    @x1 = @p1[0]
    @y1 = @p1[1]
    @x2 = @p2[0]
    @y2 = @p2[1]
    @dx = @x2-@x1
    @dy = @y2-@y1
    @slope = @dy / @dx
    @angle = (180/Math.PI) * Math.atan2(@y2-@y1, @x2-@x1)
    @angle += 360 if @angle < 0
    @distance = Math.sqrt(@dx*@dx + @dy*@dy)

  interpolate: (fraction)->
    [@dx*fraction + @x1, @dy*fraction + @y1]

  interpolations: (how_many, first, last)->
    points = []
    points.push @p1 if first
    
    to = how_many
    ++how_many
    for i in [1..to]
      fraction = i/how_many
      points.push @interpolate(fraction)
      
    points.push @p2 if last

    points


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




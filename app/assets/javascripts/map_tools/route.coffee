class MapTools.Route
  constructor: (gmap, coordinates, options)->
    if gmap.gmap
      @gmap = gmap.gmap
    else
      @gmap = gmap
      
    @coordinates = coordinates
    @options = options
    @process_points()
    @build_polyline()
    @build_segments()

  build_polyline: ->
    @poly = new $G.Polyline @polyline_options()

  build_segments: ->
    @segments = []
    length = @coordinates.length
    if length > 1
      length -= 2
      for i in [0..length]
        @segments.push new MapTools.Segment(@coordinates[i], @coordinates[i+1], @points[i], @points[i+1])
      

  process_points: ->
    if @coordinates[0] and @coordinates[0].constructor == Array
      @points = new $G.MVCArray([])
      for c in @coordinates
        @points.push new $G.LatLng c[0], c[1]
    else
      @points = new $G.MVCArray(@coordinates)
      new_coordinates = []
      for point in @coordinates
        new_coordinates.push [point.lat(), point.lng()]
      @coordinates = new_coordinates

  update_poly_path: (points = null)->
    if points
      @points = new $G.MVCArray(points)
    @poly.setPath @points

  polyline_options: ->
    _.extend {
      map: @gmap,
      path: @points,
    }, @options

  update_options: (options)->
    @options = _.extend @options, options
    @options.visible = @poly.getVisible()
    @poly.setOptions @polyline_options()

  set_options: (options)->
    @poly.setOptions options

  show: ->
    @poly.setVisible(true)

  hide: ->
    @poly.setVisible(false)


class window.BusRoute
  onmouseover: ->
  onmouseout: ->

  constructor: (encoded, bus, is_departure)->
    @encoded = encoded
    @bus     = bus
    @map     = bus.bus_group.city.map
    @is_departure = is_departure
    @is_return    = !is_departure

    @build_route()
    @build_route_markers()

    @events = {}
    @bind_meta_events()
    @bind_events()

  build_route: ->
    @decode_points()
    @options = new BusRouteOptions(@bus.color)
    @route = new Route(@map, @points, @options.initial_route_options)

  build_route_markers: ->
    arrows_images  = ArrowIcons[if @is_departure then 0 else 1]
    bus_image      = @bus.marker_image()
    @route_markers = new BusRouteMarkers @route, arrows_images, bus_image

  build_route_arrows: ->
    @route_arrows = new RouteArrows(@route, (if @is_departure then 0 else 1))

  bind_meta_events: ->
    google.maps.event.addListener @route.poly, "mouseover", => @fire_event "mouseover"
    google.maps.event.addListener @route.poly, "mouseout",  => @fire_event "mouseout"
    @route_markers.add_listener "mouseover", => @fire_event "mouseover"
    @route_markers.add_listener "mouseout",  => @fire_event "mouseout"

  bind_events: ->
    @bind_event "mouseover", => @highlight()
    @bind_event "mouseout",  => @unhighlight()

  bind_event: (event, callback)->
    @events[event] ||= []
    @events[event].push callback

  fire_event: (event)->
    if @events[event]
      for callback in @events[event]
        callback()

  decode_points: ->
    @points = google.maps.geometry.encoding.decodePath @encoded
    
  show: ->
    @route.show()
    @route_markers.show()

  hide: ->
    @route.hide()
    @route_markers.hide()

  highlight: ->
    @route.update_options @options.get_highlight_route_options()
    @route_markers.highlight()

  unhighlight: ->
    @route.update_options @options.normal_route_options
#    @route_markers.unhighlight()

  get_shortest_path: (point, start_index, start_point)->
    segments = @route.segments
    start_index ||= 0


    if start_index
      segments = segments[start_index..]

    if start_point
      start_segment = new Segment(start_point, segments[0].p2)
      segments[0] = start_segment

    end_index     = start_index
    shortest_path = false

    for i, segment of segments
      # I get a segment between the point and the closest intersection
      direction_segment = segment.closest_point(point)
      if shortest_path
        if direction_segment.distance < shortest_path.distance
          shortest_path = direction_segment
          end_index     = start_index + parseInt(i)
      else
        shortest_path = direction_segment

    [shortest_path, end_index]

  paths_to_checkpoints: (checkpoints)->
    start_point = null
    last_index = 0
    shortest_paths = []

    for point in checkpoints
      [shortest_path, last_index] = @get_shortest_path(point, last_index, start_point)
      shortest_paths.push shortest_path
      start_point = shortest_path.p2

    new BusRouteMatch(shortest_paths, @bus)

  pass_through_circles: (circles)->

  empty_markers: ->
    for marker in @markers
      marker.setMap(null)
    @markers = []
    
  markers: []
  mkmarker: (p)->
    if p[0]
      p = new google.maps.LatLng p[0], p[1]
    @markers.push new google.maps.Marker {
      map: @map.gmap,
      position: p
    }


class BusRouteOptions
  constructor: (color)->
    @color = color  

    @normal_route_options = {
      strokeWeight: 3,
      strokeColor: @color,
      strokeOpacity: 0.75,
      zIndex: MapZIndex()
      cursor: "default"
    }
  
    @initial_route_options = _.extend _.clone(@normal_route_options), {
      visible: false
    }

    @highlight_route_options = _.extend _.clone(@normal_route_options), {
      strokeWeight: 4,
      strokeOpacity: 1
    }

  get_highlight_route_options: ->
    @highlight_route_options.zIndex = MapZIndex()
    @highlight_route_options


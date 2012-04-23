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

  get_nearest_point: (point, closest_point)->
    # This closest point stuff is to only match if
    # the points are going in the same direction.
    if closest_point
      coordinates    = @route.coordinates[closest_point.index..]
      coordinates[0] = closest_point.point
    else
      coordinates = @route.coordinates[0..]

    closest_point = new RoutePointMatch point, coordinates[0], 0, coordinates[0]

    length = coordinates.length
    if length > 1
      length -= 2
      for i in [0..length]
        segment_point_1 = coordinates[i]
        segment_point_2 = coordinates[i+1]

        closest = @calculate_closest_point_from_line segment_point_1, segment_point_2, point
        closest_point_to_line = new RoutePointMatch point, closest, i, segment_point_1

        if closest_point_to_line.pseudo_distance() < closest_point.pseudo_distance()
          closest_point = closest_point_to_line

    closest_point

  pass_through_circles: (circles)->
    last_nearest_point = null
    distances_left = []
    
    for circle in circles
      point = [circle.x, circle.y]
      nearest_point = @get_nearest_point(point, last_nearest_point)
      
      distance_left = (nearest_point.real_distance() - circle.radius)
      distances_left.push(distance_left)

      last_nearest_point = nearest_point

    new BusRouteMatch(distances_left, @bus)
      
      
  # TODO: Refactor to not use Sylverster
  ccalculate_closest_point_from_line: (a, b, p)->
    a = $V a
    b = $V b
    p = $V p

    ap = p.subtract a
    ab = b.subtract a

    ab2   = ab.e(1)*ab.e(1) + ab.e(2)*ab.e(2)
    ap_ab = ap.e(1)*ab.e(1) + ap.e(2)*ab.e(2)



    if ab2 != 0
      t     = ap_ab / ab2
      if t < 0
        t = 0
      else if t > 1
        t = 1
    else
      t = 1


    console.log "Hi", ab.multiply t

    closest = a.add(ab.multiply t) # Closest
    [closest.e(1), closest.e(2)]

  # TODO: Refactor to not use Sylverster
  calculate_closest_point_from_line: (a, b, p)->
    ap = [p[0]-a[0], p[1]-a[1]]
    ab = [b[0]-a[0], b[1]-a[1]]

    ab2   = ab[0]*ab[0] + ab[1]*ab[1]
    ap_ab = ap[0]*ab[0] + ap[1]*ab[1]


    if ab2 != 0
      t     = ap_ab / ab2
      if t < 0
        t = 0
      else if t > 1
        t = 1
    else
      t = 1



    ab_m_t = [ab[0]*t, ab[1]*t]
    [a[0]+ab_m_t[0], a[1]+ab_m_t[1]] # Closest


  mkmarker: (p)->
    if p[0]
      p = new google.maps.LatLng p[0], p[1]

    new google.maps.Marker {
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


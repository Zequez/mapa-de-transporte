class MDC.Directions.CheckpointDirection extends Utils.Eventable
  # Events
  # - mouseover
  # - mouseout
  
  constructor: (segment, route)->
    @map        = route.map
    @gmap       = @map.gmap
    @segment    = segment
    @route      = route
    @route_bus  = route.bus
    @bus_marker = @route_bus.marker_image()
    
    @create_polyline()
    @create_marker()
    @bind_marker()

  create_polyline: ->
    @poly = new $G.Polyline @polyline_options()

  polyline_options: ->
    {
      strokeWeight: 1,
      strokeColor: @route_bus.color,
      strokeOpacity: 1,
      clickable: false,
      path: @segment.path(),
      map: @gmap,
      zIndex: 10
    }

  create_marker: ->
    @marker = new $G.Marker @marker_options()

  marker_options: ->
    {
      map: @gmap,
      position: $LatLng(@segment.middle_point()),
      icon: @bus_marker,
      zIndex: 9999,
      flat: true,
      cursor: "default"
    }

  bind_marker: ->
    $G.event.clearInstanceListeners(@marker)
    $G.event.addListener @marker, 'mouseover', =>
      @fire_event('mouseover')
    $G.event.addListener @marker, 'mouseout', =>
      @fire_event('mouseout')

  remove: ->
    @poly.setMap null
    @marker.setMap null
    @delete_events()

  hide: ->
    @poly.setVisible false
    @marker.setVisible false

  show: ->
    @poly.setVisible true
    @marker.setVisible true

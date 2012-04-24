class window.BusPath
  constructor: (bus, segment, gmap)->
    @gmap = gmap
    @segment = segment
    @bus = bus
    @create_polyline()
    @create_marker()
    @bind_marker()

  create_polyline: ->
    @poly = new $G.Polyline @polyline_options()

  polyline_options: ->
    {
      strokeWeight: 1,
      strokeColor: 'red',
      strokeOpacity: 1,
      clickable: false,
      path: @segment.path(),
      map: @gmap
    }

  create_marker: ->
    @marker = new $G.Marker @marker_options()

  marker_options: ->
    {
      map: @gmap,
      position: $LatLng(@segment.middle_point()),
      icon: @bus.marker_image(),
      zIndex: 9999
    }

  bind_marker: ->
    $G.event.clearInstanceListeners(@marker)
    $G.event.addListener @marker, 'mouseover', => @bus.highlight_routes()
    $G.event.addListener @marker, 'mouseout', => @bus.unhighlight_routes()

  update_polyline: ->
    @poly.setPath @segment.path()

  update_marker: (bus)->
    if bus != @bus
      @marker.setIcon(@bus.marker_image())
    @marker.setPosition($LatLng @segment.middle_point())
    @bind_marker()

  update: (bus, segment)->
    [@bus, bus] = [bus, @bus]
    @segment = segment
    @update_polyline()
    @update_marker(bus)

    @show()

  hide: ->
    @poly.setVisible false
    @marker.setVisible false
  show: ->
    @poly.setVisible true
    @marker.setVisible true

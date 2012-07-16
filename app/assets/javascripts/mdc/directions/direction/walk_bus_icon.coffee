class MDC.Directions.Direction.WalkBusIcon extends Utils.Eventable
  constructor: (@latlng, @buses, @gmap)->
    @bus = @buses[0] # We might need this in the future.

    @build_marker()
    @bind_marker()

  build_marker: ->
    @marker = new MDC.Directions.Direction.BusesIconsOverlay(@bus.data, @bus.color, @latlng, @gmap)
#    @marker = new $G.Marker @marker_options()

#  marker_options: ->
#    {
#      map: @gmap
#      position: @latlng
#      icon: MDC.Helpers.BusesIcons.get(@bus.data["id"])
#      cursor: "default"
#      flat: true
#    }

  bind_marker: ->
    $G.event.addListener @marker, "mouseover", =>
      @fire_event('mouseover')

    $G.event.addListener @marker, "mouseout", =>
      @fire_event('mouseout')

#  show: -> @marker.setVisible true
#  hide: -> @marker.setVisible false
  show: -> @marker.show()
  hide: -> @marker.hide()
  destroy: -> @marker.setMap null

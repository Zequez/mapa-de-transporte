class MDC.SellLocations.Displayer extends Utils.Eventable
  constructor: (data, @gmap)->
    @build_markers(data)

  build_markers: (data)->
    @markers = []
    for dat in data
      marker = new MDC.SellLocations.Marker(dat, @gmap)
      @bind_marker marker
      @markers.push marker
    null

  bind_marker: (marker)->
    marker.add_listener "edit", (data, marker)=>
      @fire_event('edit', data, marker)

  show: ->
    marker.show() for marker in @markers
    null

  hide: ->
    marker.hide() for marker in @markers
    null
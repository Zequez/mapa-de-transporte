class MDC.SellLocations.Displayer
  constructor: (data, @gmap)->
    @build_markers(data)

  build_markers: (data)->
    @markers = []
    for dat in data
      @markers.push new MDC.SellLocations.Marker(dat, @gmap)
    null

  show: ->
    marker.show() for marker in @markers
    null

  hide: ->
    marker.hide() for marker in @markers
    null
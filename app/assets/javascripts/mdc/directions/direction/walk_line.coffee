class MDC.Directions.Direction.WalkLine
  constructor: (@segment, @color, @gmap)->
    @create_polyline()

  create_polyline: ->
    @polyline = new $G.Polyline @polyline_options()

  polyline_options: ->
    {
      map: @gmap
      path: @segment.path()
      strokeWeight: 1
      strokeColor: @color.normal
      strokeOpacity: 0.75
      clickable: false
      visible: false
    }

  show: -> @polyline.setVisible true
  hide: -> @polyline.setVisible false
  destroy: -> @polyline.setMap null
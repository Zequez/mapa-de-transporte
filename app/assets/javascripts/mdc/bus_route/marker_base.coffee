class MDC.BusRoute.MarkerBase
  constructor: (gmap, point, image)->
    @gmap  = gmap
    @point = point
    @image = image
    @add_to_map()

  add_to_map: ->
    @marker = new $G.Marker @options()

  show: ->
    @marker.setVisible(true)

  hide: ->
    @marker.setVisible(false)

  highlight: ->
    @marker.setZIndex(MDC.Helpers.MapZIndex())

#  unhighlight: ->

  add_listener: (event, callback)->
    $G.event.addListener @marker, event, callback

  options: ->
    {
      map: @gmap,
      clickable: false,
      position: @point,
      flat: true,
      icon: @image
      visible: false,
      cursor: "default",
      zIndex: MDC.Helpers.MapZIndex()
    }


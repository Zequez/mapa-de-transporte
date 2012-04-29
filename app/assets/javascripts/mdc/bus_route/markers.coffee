class MDC.BusRoute.Markers
  min_gap: 0.020 # 500m aprox

  visible: null
  base_zoom: 14
  zoom: 0

  constructor: (route, arrows_images)->
    @route = route
    @gmap  = @route.gmap
    @arrows_images = arrows_images

    @zoom = 0

    @events = {}

#    @bind_map()
#
#  bind_map: ->
#    $G.event.addListener @gmap, "zoom_changed", =>
#      @zoom = @gmap.getZoom()
#      if @visible
#        @show()



#  recalculate_markers_based_on_zoom: ->
    

  ensure_markers: ->
    if !@markers
      @calculate_markers()
      @markers = @buses_icons.concat @arrows

  calculate_markers: ->
    segments = @route.segments

    @arrows = []
    @buses_icons = []
    
    first = true

    poison_bit = 1

    ### IF_POISON
      poison_bit = 20
    ###
    
    for segment in segments
      if segment.distance > @min_gap
        how_many = Math.floor(segment.distance*poison_bit/@min_gap)
      else
        how_many = 0

      for point in segment.interpolations(how_many, first, true)
        point = $LatLng point
        @arrows.push new MDC.BusRoute.ArrowMarker(@gmap, point, segment.angle, @arrows_images)

      first = false

    null

  show: ->
    @visible = true
    @send_to_markers("show")
  hide: ->
    @visible = false
    @send_to_markers("hide")
  highlight:   -> @send_to_markers("highlight")

  send_to_markers: (action)->
    @ensure_markers()
    for marker in @markers
      marker[action]()

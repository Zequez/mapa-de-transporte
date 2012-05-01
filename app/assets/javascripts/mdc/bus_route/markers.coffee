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
      @markers = @arrows

  calculate_markers: ->
    segments = @route.segments

    @arrows = []
    
    first = true

    poison_bit = 1

    ### IF_POISON
      poison_bit = 20
    ###


    for i, segment of segments
      current_segment_number = parseInt(i)+1

      # Travel to the last segment leaving a fixed space between markers.
      loop
        if distance_to_travel > segment.distance
          distance_to_travel = distance_to_travel - segment.distance

          console.log i, segments.length
          if current_segment_number == segments.length
            @add_marker(segment.p2, segment.angle)
          break
        else
          segment            = segment.travel_x_distance distance_to_travel
          distance_to_travel = @min_gap

          @add_marker(segment.p1, segment.angle)
          # We add a marker on the last point of the route.

     

#      total_distance += segment.distance
#
#    total_markers = Math.floor(total_distance / @min_gap + 1)
#
#
#    counted_distance = 0
#    current_segment  = segments[0]
#
#    for marker_i in [0..total_markers]
#      counted_distance =
#
#    for segment in segments
#      while segment.distance
#
#      if segment.distance > @min_gap
#        how_many = Math.floor(segment.distance*poison_bit/@min_gap)
#      else
#        how_many = 0
#
#      for point in segment.interpolations(how_many, first, true)
#        point = $LatLng point
#        @arrows.push new MDC.BusRoute.ArrowMarker(@gmap, point, segment.angle, @arrows_images)
#
#      first = false

    null

  add_marker: (point, angle)->
    point = $LatLng point
    @arrows.push new MDC.BusRoute.ArrowMarker(@gmap, point, angle, @arrows_images)

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

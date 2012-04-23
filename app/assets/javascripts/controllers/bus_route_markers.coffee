class window.BusRouteMarkers
  max_gap: 0.005 # 500m aprox
  min_gap: 0.002 # 200m aprox

  visible: null

  constructor: (route, arrows_images, bus_image)->
    @route = route
    @gmap  = @route.gmap
    @arrows_images = arrows_images
    @bus_image = bus_image

    @events = {}

  ensure_markers: ->
    if !@markers
      @calculate_markers()
      @markers = @buses_icons.concat @arrows
      @add_saved_events()

  calculate_markers: ->
    module = google.maps.geometry.spherical
    points = @route.coordinates
    segments = @route.segments

    @arrows = []
    @buses_icons = []

    length = points.length

    first = true
    
    for segment in segments

      if segment.distance > @max_gap
        how_many = Math.floor(segment.distance/@max_gap)
      else if segment.distance > @min_gap
        how_many = 1
      else
        continue

      for point in segment.interpolations(how_many, first, true)
        point = $LatLng point
        @buses_icons.push new BusImageMarker(@gmap, point, @bus_image)
        @arrows.push new ArrowMarker(@gmap, point, segment.angle, @arrows_images)

      first = false



    null

  show: ->
    @visible = true
    @send_to_markers("show")
  hide: ->
    @visible = false
    @send_to_markers("hide")
  highlight:   -> @send_to_markers("highlight")
#  unhighlight: -> @send_to_markers("unhighlight")

  send_to_markers: (action)->
    @ensure_markers()
    for marker in @markers
      marker[action]()

  add_listener: (event, callback)->
    if @markers
      if @events
        @add_saved_events()

      for marker in @markers
        marker.add_listener event, callback
    else
      @events[event] = callback

  add_saved_events: ->
    events = @events
    @events = false
    for event, callback of events
      @add_listener(event, callback)

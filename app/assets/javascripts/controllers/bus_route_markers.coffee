class window.BusRouteMarkers
  max_gap: 500
  min_gap: 200

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
    points = @route.points.getArray()

    @arrows = []
    @buses_icons = []

    length = points.length

    if length > 1
      length -= 2
      for i in [0..length]
        point_from = points[i]
        point_to = points[i+1]

        first = (i == 0)
        last  = (i == length)

        x1 = point_from.lat()
        y1 = point_from.lng()
        x2 = point_to.lat()
        y2 = point_to.lng()

        angle = (180/Math.PI) * Math.atan2(y2-y1, x2-x1)
        angle += 360 if angle < 0

        distance = module.computeDistanceBetween(point_from, point_to)

        first_mark = 1
        last_mark  = -1
        first_mark = 0 if first
        last_mark  = 0 if last

        fractions = 1

        if distance > @max_gap
          fractions += Math.floor(distance/@max_gap)
        else if distance > @min_gap and not (first or last)
          fractions += 1

        mark_from = 0 + first_mark
        mark_to   = fractions + last_mark

        if mark_from <= mark_to
          for j in [mark_from..mark_to]
            point = module.interpolate(point_from, point_to, j / fractions)

            @buses_icons.push new BusImageMarker(@gmap, point, @bus_image)
            @arrows.push new ArrowMarker(@gmap, point, angle, @arrows_images)


    null

  show:        -> @send_to_markers("show")
  hide:        -> @send_to_markers("hide")
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

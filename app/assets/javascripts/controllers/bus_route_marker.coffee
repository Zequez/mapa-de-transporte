class window.BusRouteMarker
  constructor: (gmap, point, image)->
    @gmap  = gmap
    @point = point
    @image = image
    @add_to_map()

  add_to_map: ->
    @marker = new google.maps.Marker @options()

  show: ->
    @marker.setVisible(true)

  hide: ->
    @marker.setVisible(false)

  highlight: ->
    @marker.setZIndex(MapZIndex())

#  unhighlight: ->
    

  add_listener: (event, callback)->
    google.maps.event.addListener @marker, event, callback

  options: ->
    {
      map: @gmap,
      position: @point,
      flat: true,
      icon: @image
      visible: false,
      cursor: "default",
      zIndex: MapZIndex()
    }

class window.BusImageMarker extends BusRouteMarker
  options: ->
    # For some reason this doesn't seems to work on mouse over
#    _.extend super(), {
#      shape: BusesIcons.shape
#    }
    super()


class window.ArrowMarker extends BusRouteMarker
  constructor: (gmap, point, angle, images)->
    @angle  = angle
    @images = images
    @calculate_image()
    super(gmap, point, @image)

  calculate_image: ->
    rest = @angle % 45
    if rest < 22
      angle = @angle - rest
    else
      angle = @angle + (45-rest)

    angle = 0 if angle == 360

    @image = @images[angle]
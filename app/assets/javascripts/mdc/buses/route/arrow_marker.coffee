##= require ./marker_base
#
#class MDC.Buses.Route.ArrowMarker extends MDC.Buses.Route.MarkerBase
#  constructor: (gmap, point, angle, images)->
#    @angle  = angle
#    @images = images
#    @calculate_image()
#    super(gmap, point, @image)
#
#  calculate_image: ->
#    rest = @angle % 45
#    if rest < 22
#      angle = @angle - rest
#    else
#      angle = @angle + (45-rest)
#
#    angle = 0 if angle == 360
#
#    @image = @images[angle]
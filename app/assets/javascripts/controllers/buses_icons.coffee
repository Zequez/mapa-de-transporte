#class BusesIcons
#  url: "/buses_images.png"
#
#  images: {}
#
##  shape: {
##    type: "rect",
##    coords: [0, 0, 12, 20]
##  }
#
#  constructor: ->
#    @size   = new google.maps.Size(24, 12)
#    @anchor = new google.maps.Point(11, 14)
#
#  get: (id)->
#    return @images[id] if @images[id]
#    origin = new google.maps.Point(0, (id-1)*12)
#    @images[id] = new google.maps.MarkerImage @url, @size, origin, @anchor
#
#
#window.BusesIcons = new BusesIcons
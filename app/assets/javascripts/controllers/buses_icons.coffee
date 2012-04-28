class BusesIcons
  url: "/buses_images.png"

  images: {}

  w: 23
  h: 11

#  shape: {
#    type: "rect",
#    coords: [0, 0, 12, 20]
#  }

  constructor: ->
    @size   = new google.maps.Size(@w, @h)
    @anchor = new google.maps.Point(@w/2, @h/2)

  get: (id)->
    return @images[id] if @images[id]
    origin = new google.maps.Point(0, (id-1)*@h)
    @images[id] = new google.maps.MarkerImage @url, @size, origin, @anchor


window.BusesIcons = new BusesIcons
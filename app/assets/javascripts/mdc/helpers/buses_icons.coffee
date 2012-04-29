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
    @size   = new $G.Size(@w, @h)
    @anchor = new $G.Point(@w/2, @h/2)

  get: (id)->
    return @images[id] if @images[id]
    origin = new $G.Point(0, (id-1)*@h)
    @images[id] = new $G.MarkerImage @url, @size, origin, @anchor

MDC.Helpers.BusesIcons = new BusesIcons
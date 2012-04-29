class NumberIcons
  url: "/assets/sprites.png"

  images: {}
  
  shape: {
    type: "circle",
    coords: [25, 25, 25]
  }

  constructor: ->
    @size   = new $G.Size(50, 50)
    @anchor = new $G.Point(25, 25)

  get: (i)->
    return @images[i] if @images[i]
    origin = new $G.Point(0, (i-1)*50)
    @images[i] = new $G.MarkerImage @url, @size, origin, @anchor


MDC.Helpers.NumberIcons = new NumberIcons
class NumberIcons
  url: MDC.CONFIG.sprites_path

  images: {}

  sprite_positions: [[122, 0], [61, 0], [0, 0]]

  width: 50
  height: 50

  shape: {
    type: "circle",
    coords: [25, 25, 25]
  }

  constructor: ->
    @size   = new $G.Size(@width, @height)
    @anchor = new $G.Point(@width/2, @height/2)

  get: (i)->
    --i
    return @images[i] if @images[i]
    origin = new $G.Point(@sprite_positions[i][0], @sprite_positions[i][1])
    @images[i] = new $G.MarkerImage @url, @size, origin, @anchor


MDC.Helpers.NumberIcons = new NumberIcons
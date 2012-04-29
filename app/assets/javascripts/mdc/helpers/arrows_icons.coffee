class ArrowsIcons
  images: {}

  sprite_x: 303,
  sprite_y: 0,

  colors: [0, 1]

  angles: [0, 45, 90, 135, 180, 225, 270, 315]

  url: "/assets/sprites.png"

  width: 9

  constructor: ->
    @size   = new $G.Size(@width, @width)
    @anchor = new $G.Point(Math.floor(@width/2), Math.floor(@width/2))
    @generate()

  generate: ->
    Point =
    for color in @colors
      @images[color] = {}
      for angle, angle_position in @angles
        x = @width*color + @sprite_x
        y = @width*angle_position + @sprite_y

        origin = new $G.Point(x, y)

        @images[color][angle] = new $G.MarkerImage(@url, @size, origin, @anchor)


MDC.Helpers.ArrowsIcons = (new ArrowsIcons).images
    

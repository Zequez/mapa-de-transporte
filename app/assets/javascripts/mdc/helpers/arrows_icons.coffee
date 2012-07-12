class ArrowsIcons
  images: {}

#  colors: [0, 1]

#  angles: [0, 45, 90, 135, 180, 225, 270, 315]

  url: MDC.CONFIG.sprites_path

  sprite_positions: [
    {
      0: [102, 247]
      45: [258, 123]
      90: [258, 103]
      135: [82, 247]
      180: [62, 247]
      225: [191, 216]
      270: [249, 163]
      315: [249, 143]
    },
    {
      0: [62, 267]
      45: [142, 247]
      90: [122, 247]
      135: [242, 247]
      180: [222, 247]
      225: [202, 247]
      270: [182, 247]
      315: [162, 247]
    }
  ]

  width: 9
  height: 9

  constructor: ->
    @size   = new $G.Size(@width, @height)
    @anchor = new $G.Point(Math.floor(@width/2), Math.floor(@height/2))
    @generate()

  generate: ->
    for color, sprites of @sprite_positions
      @images[color] = {}
      for angle, angle_position of sprites

        origin = new $G.Point(angle_position[0], angle_position[1])
        @images[color][angle] = new $G.MarkerImage(@url, @size, origin, @anchor)


MDC.Helpers.ArrowsIcons = (new ArrowsIcons).images
    

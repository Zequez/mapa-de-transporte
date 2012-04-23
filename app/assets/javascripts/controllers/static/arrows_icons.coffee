class ArrowIcons
  images: {}

  colors: [0, 1]

  angles: [0, 45, 90, 135, 180, 225, 270, 315]

  url: "/assets/arrows.png"

  width: 9

  constructor: ->
    @size   = new google.maps.Size(@width, @width)
    @anchor = new google.maps.Point(Math.floor(@width/2), Math.floor(@width/2))
    @generate()

  generate: ->
    Point =
    for color in @colors
      @images[color] = {}
      for angle, angle_position in @angles
        x = @width*color
        y = @width*angle_position

        origin = new google.maps.Point(x, y)

        @images[color][angle] = new google.maps.MarkerImage(@url, @size, origin, @anchor)

window.ArrowIcons = (new ArrowIcons).images
    

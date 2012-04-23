class NumberIcons
  url: "/assets/number_icons.png"

  images: {}
  
  shape: {
    type: "rect",
    coords: [0, 0, 27, 27]
  }

  constructor: ->
    @size   = new google.maps.Size(27, 27)
    @anchor = new google.maps.Point(14, 40)

  get: (i)->
    return @images[i] if @images[i]
    origin = new google.maps.Point(0, (i-1)*27)
    @images[i] = new google.maps.MarkerImage @url, @size, origin, @anchor


window.NumberIcons = new NumberIcons
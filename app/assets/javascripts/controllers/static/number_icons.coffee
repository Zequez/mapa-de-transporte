class NumberIcons
  url: "/assets/sprites.png"

  images: {}
  
  shape: {
    type: "circle",
    coords: [25, 25, 25]
  }

  constructor: ->
    @size   = new google.maps.Size(50, 50)
    @anchor = new google.maps.Point(25, 25)

  get: (i)->
    return @images[i] if @images[i]
    origin = new google.maps.Point(0, (i-1)*50)
    @images[i] = new google.maps.MarkerImage @url, @size, origin, @anchor


window.NumberIcons = new NumberIcons
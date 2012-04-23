class BusesIcons
  url: "/buses_images.png"

  images: {}

  shape: {
    type: "rect",
    coords: [0, 0, 18, 20]
  }

  constructor: ->
    @size   = new google.maps.Size(18, 10)
    @anchor = new google.maps.Point(9, 12)

  get: (id)->
    return @images[id] if @images[id]
    origin = new google.maps.Point(0, (id-1)*10)
    @images[id] = new google.maps.MarkerImage @url, @size, origin, @anchor


window.BusesIcons = new BusesIcons
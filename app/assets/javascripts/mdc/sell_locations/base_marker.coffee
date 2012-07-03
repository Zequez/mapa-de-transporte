class MDC.SellLocations.BaseMarker extends Utils.Eventable
  constructor: (@data, @gmap)->
    @build_marker()

  build_marker: ->
    @marker = new $G.Marker @marker_options()

  marker_options: ->
    {
      map: @gmap
      position: @get_latlng()
      icon: @get_image()
      visible: false
      cursor: "default"
#      shape: @get_shape()
    }

  get_latlng: ->
    new $G.LatLng @data["lat"], @data["lng"]

  show: ->
    @marker.setVisible true

  hide: ->
    @marker.setVisible false

  destroy: ->
    @marker.setMap null
    $G.event.clearInstanceListeners(@marker)

  get_image: ->
    if @data["card_selling"]
      @get_selling_image()
    else if @data["card_reloading"]
      @get_reloading_image()
    else
      @get_ticket_image()

  get_reloading_image: ->
    MDC.SellLocations.BaseMarker.ReloadingImage ||= do ->
      MDC.SellLocations.BaseMarker.create_image 2

  get_selling_image: ->
    MDC.SellLocations.BaseMarker.SellingImage ||= do ->
      MDC.SellLocations.BaseMarker.create_image 1

  get_ticket_image: ->
    MDC.SellLocations.BaseMarker.TicketImage ||= do ->
       MDC.SellLocations.BaseMarker.create_image 0

MDC.SellLocations.BaseMarker.create_image = (number)->
  w = 17
  h = 25
  sprites_positions = [[214, 185], [239, 0], [247, 36]]
  size   = new $G.Size(w, h)
  origin = new $G.Point(sprites_positions[number][0], sprites_positions[number][1])
  url    = "/assets/sprites.png"

  new $G.MarkerImage url, size, origin
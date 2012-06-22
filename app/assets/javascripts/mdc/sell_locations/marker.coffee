class MDC.SellLocations.Marker
  window: $(window)

  constructor: (@data, @gmap)->
    @build_marker()
    @bind_marker()

  build_marker: ->
    @marker = new $G.Marker @marker_options()

  marker_options: ->
    console.log @get_image()
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

  bind_marker: ->
    $G.event.addListener @marker, "mouseover", (e)=>
      @start_mouseover()

    $G.event.addListener @marker, "mouseout", (e)=>
      @hide_popup()
      @end_mouseover()

  start_mouseover: ->
    @window_event = (e)=>
      x = e.pageX
      y = e.pageY
      @show_popup(x, y)

    @window.mousemove @window_event

  end_mouseover: ->
    @window.unbind "mousemove", @window_event

  build_popup: ->
    @popup = new MDC.SellLocations.MarkerPopup(@data)

  show_popup: (page_x, page_y)->
    @build_popup() if not @popup
    @popup.show(page_x, page_y)

  hide_popup: ->
    @build_popup() if not @popup
    @popup.hide()

  show: ->
    @marker.setVisible true

  hide: ->
    @marker.setVisible false
    @popup.hide()


  get_image: ->
    if @data["card_selling"]
      @get_selling_image()
    else if @data["card_reloading"]
      @get_reloading_image()
    else
      @get_ticket_image()

  get_reloading_image: ->
    MDC.SellLocations.Marker.ReloadingImage ||= do ->
      MDC.SellLocations.Marker.create_image 2

  get_selling_image: ->
    MDC.SellLocations.Marker.SellingImage ||= do ->
      MDC.SellLocations.Marker.create_image 1

  get_ticket_image: ->
    MDC.SellLocations.Marker.TicketImage ||= do ->
       MDC.SellLocations.Marker.create_image 0

MDC.SellLocations.Marker.create_image = (number)->
  w = 19
  h = 27
  size   = new $G.Size(w, h)
  origin = new $G.Point(19*number, 0)
  url    = "/assets/sell_locations_marker.png"

  new $G.MarkerImage url, size, origin


#  get_shape: ->
#    MDC.SellLocations.Marker.Shape ||= do ->
#      {
#        coords: [0, 22, 19, 22]
#        type: "rect"
#      }
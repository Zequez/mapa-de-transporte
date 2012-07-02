# Events
# - edit

class MDC.SellLocations.Marker extends MDC.SellLocations.BaseMarker
  window: $(window)

  constructor: (data, gmap)->
    super data, gmap
    @bind_marker()

  bind_marker: ->
    $G.event.addListener @marker, "mouseover", (e)=>
      @start_mouseover()

    $G.event.addListener @marker, "mouseout", (e)=>
      @hide_popup()
      @end_mouseover()

    $G.event.addListener @marker, "rightclick", (e)=>
      @fire_event('edit', @data, @marker)

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

  hide: ->
    super()
    @hide_popup()




#  get_shape: ->
#    MDC.SellLocations.Marker.Shape ||= do ->
#      {
#        coords: [0, 22, 19, 22]
#        type: "rect"
#      }
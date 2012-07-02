class MDC.SellLocations.Suggestion.Popup
  constructor: (@form, @marker, @gmap)->
    @build_popup()
    @open_popup()

  build_popup: ->
    @popup = new InfoBox @popup_options()

  open_popup: ->
    @popup.open @gmap, @marker

  popup_options: ->
    {
      content: @form.get_element()
      closeBoxURL: ""
      alignBottom: true
      pixelOffset: new $G.Size(0, -25)
#      enableEventPropagation: true
#      position: $LatLng @data.lat, @data.lng
#      size: new $G.Size(100, 100)
    }

  show: ->
    @popup.show()

  hide: ->
    @popup.hide()

  destroy: ->
    console.log @form
    console.log @popup
    @popup.close()
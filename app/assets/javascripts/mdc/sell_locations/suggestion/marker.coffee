# Events
# - change

class MDC.SellLocations.Suggestion.Marker extends MDC.SellLocations.BaseMarker
  constructor: (@data, @gmap)->
    super data, gmap
    @bind_marker()

  marker_options: ->
    _.extend super(), {
      draggable: true,
      cursor: 'hand'
      visible: true
      raiseOnDrag: false
    }

  bind_marker: ->
    $G.event.addListener @marker, 'dragend',  (e)=>
      @fire_event 'change', e.latLng

  get_element: ->
    @marker
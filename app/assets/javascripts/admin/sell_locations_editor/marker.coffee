# Events
# - change
# - select

class SellLocationsEditor.Marker extends Utils.Eventable
  constructor: (@gmap, @latlng)->
    @add_to_map()
    @bind_marker()

  add_to_map: ->
    @marker = new $G.Marker @options()

  options: ->
    {
      map: @gmap,
      draggable: true,
      position: @latlng,
      flat: true,
      cursor: "default",
      icon: @blue_icon(),
      raiseOnDrag: false
    }

  bind_marker: ->
    $G.event.addListener @marker, 'dragend', (latlng)=>
      @fire_event('change', latlng.latLng)

    $G.event.addListener @marker, 'click', =>
      @fire_event('select')

  highlight: ->
    @marker.setIcon @red_icon()

  unhighlight: ->
    @marker.setIcon @blue_icon()

  set_latlng: (@latlng)->
    @marker.setPosition @latlng

  remove: ->
    @marker.setMap null

  red_icon: ->
    SellLocationsEditor.Marker.red_icon ||=
      new $G.MarkerImage("http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|FF0000",
        new $G.Size(21, 34),
        new $G.Point(0,0),
        new $G.Point(10, 34));

  blue_icon: ->
    SellLocationsEditor.Marker.blue_icon ||=
      new $G.MarkerImage("http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|0000FF",
        new $G.Size(21, 34),
        new $G.Point(0,0),
        new $G.Point(10, 34));
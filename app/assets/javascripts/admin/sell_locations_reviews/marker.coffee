# Events
# - change

class SellLocationsReviews.Marker extends SellLocationsEditor.Marker
  draggable: (boolean)->
    @marker.setDraggable boolean

  green: ->
    @marker.setIcon @green_icon()

  green_icon: ->
    SellLocationsReviews.Marker.green_icon ||=
      new $G.MarkerImage("http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|00FF00",
        new $G.Size(21, 34),
        new $G.Point(0,0),
        new $G.Point(10, 34));

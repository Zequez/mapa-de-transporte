class window.Checkpoint extends Eventable
  # Events
  # - closed
  # - changed
  # - removed

  constructor: (map, latlng, number)->
    @map     = map
    @gmap    = map.gmap
    @number  = number

    @latlng = latlng
    @set_point()
    @circle = null

    @add_circle_to_map()
    @add_number_to_map()

    @bind_circle_events()

  set_point: ->
    @point  = [@latlng.lat(), @latlng.lng()]

  add_circle_to_map: ->
    @circle = new google.maps.Circle @circle_options()
  
  circle_options: ->
    {
      map: @gmap,
      center: @latlng,
      radius: 200,
      strokeColor: "#132230",
      fillColor: "#132230",
      strokeOpacity: 0.6,
      fillOpacity: 0.3,
      strokeWeight: 1
    }

  add_number_to_map: ->
    @number_marker = new google.maps.Marker @number_options()

  number_options: ->
    {
      map: @gmap,
      position: @latlng,
      flat: true,
      clickable: false,
      icon: NumberIcons.get(@number)
    }

  bind_circle_events: ->
    $G.event.addListener @circle, "mousedown", (e)=>
      if e.b.button == 0 # Left click
        @gmap.set('draggable', false)

        map_move_listener = $G.event.addListener @gmap, "mousemove",   (e)=>
          @move_position(e.latLng)

        circle_move_listener = $G.event.addListener @circle, "mousemove", (e)=>
          @move_position(e.latLng)

        $G.event.addListenerOnce @circle, "mouseup", (e)=>
          @gmap.set('draggable', true)
          $G.event.removeListener map_move_listener
          $G.event.removeListener circle_move_listener
          @set_position(e.latLng)
          @fire_event('changed')

        $G.event.addListenerOnce @gmap, "mouseup", (e)=>
          $G.event.trigger @circle, "mouseup", e

    $G.event.addListener @circle, "rightclick", (e)=>
      @fire_event('closed')

  # This just sets the position of the circle
  move_position: (latlng)->
    @latlng = latlng
    @circle.setCenter latlng

  set_position: (latlng)->
    @latlng = latlng if latlng
    @move_position(@latlng)
    @number_marker.setPosition @latlng
    @set_point()

  set_number: (number)->
    @number = number
    @number_marker.setIcon(NumberIcons.get(@number))
#    @element.set_value(@number)

  remove: ->
    @circle.setMap(null)
    @number_marker.setMap(null)
    @fire_event('removed')
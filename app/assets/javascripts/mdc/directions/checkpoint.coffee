class MDC.Directions.Checkpoint extends Utils.Eventable
  # Events
  # - closed # Deprecated
  # - rightclick
  # - changed
  # - removed
  # - middleclick

  constructor: (map, latlng, number)->
    @map     = map
    @gmap    = map.gmap
    @number  = number

    @latlng = latlng
    @set_point()
    @circle = null

    @add_number_to_map()
    @bind_number_events()

  set_point: ->
    @point  = [@latlng.lat(), @latlng.lng()]


  add_number_to_map: ->
    @number_marker = new $G.Marker @number_options()

  number_options: ->
    {
      map: @gmap,
      position: @latlng,
      draggable: true,
      flat: true,
      icon: @get_icon(),
      shape: MDC.Helpers.NumberIcons.shape,
      raiseOnDrag: false
    }


  bind_number_events: ->
    $G.event.addListener @number_marker, 'dragend', (e)=>
      @set_position e.latLng
      @fire_event('changed')
      
    $G.event.addListener @number_marker, 'rightclick', =>
      @fire_event('closed')
      @fire_event('rightclick')

    $G.event.addListener @number_marker, 'mouseup', (e)=>
      if e.b.button == 1
        @fire_event('middleclick')

  set_position: (latlng)->
    @latlng = latlng
    @set_point()

  set_number: (number)->
    @number = number
    @number_marker.setIcon(@get_icon())

  remove: ->
    @number_marker.setMap(null)
    @fire_event('removed')

  get_icon: ->
    MDC.Helpers.NumberIcons.get(@number)

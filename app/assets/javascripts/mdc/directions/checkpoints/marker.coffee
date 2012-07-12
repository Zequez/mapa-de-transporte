class MDC.Directions.Checkpoints.Marker extends Utils.Eventable
  # Events
  # - closed # Deprecated
  # - rightclick
  # - changed
  # - removed
  # - middleclick

  checkpoint: null
  marker: null
  visible: false


  constructor: (@gmap, @number)->
    ++@number

  construct: ->
    if not @marker
      @build_marker()
      @bind_marker()

  build_marker: ->
    @marker = new $G.Marker @marker_options()

  marker_options: ->
    {
      map: @gmap,
      position: @latlng,
      draggable: true,
      flat: true,
      icon: @get_icon(),
      shape: MDC.Helpers.NumberIcons.shape,
      raiseOnDrag: false
      visible: false
    }

  bind_marker: ->
    $G.event.addListener @marker, 'dragend', (e)=>
      @latlng = e.latLng
      @fire_event('move', @latlng)
      
    $G.event.addListener @marker, 'rightclick', =>
      @fire_event('rightclick')

    $G.event.addListener @marker, 'mouseup', (e)=>
      if e["b"]["button"] == 1
        @fire_event('middleclick')


  set_latlng: (@latlng)->
    @update_marker_position()

  update_marker_position: ->
    @construct()
    @marker.setPosition @latlng
    @show()

  show: (latlng)->
    if latlng
      @set_latlng(latlng)
    else
      @construct()

    @marker.setVisible true
    @visible = true

  hide: ->
    if @marker
      @marker.setVisible false
    @visible = false

  get_icon: ->
    # Refactor to create it's own icon.
    MDC.Helpers.NumberIcons.get(@number)

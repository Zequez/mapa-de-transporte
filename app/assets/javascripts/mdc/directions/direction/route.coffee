class MDC.Directions.Direction.Route extends Utils.Eventable
  polyline: null

  constructor: (@segments, @color, @gmap)->
    @calculate_values()

  calculate_values: ->
    @distance = 0
    for segment in @segments
      @distance += segment.distance_in_meters()
    @distance = parseInt(@distance)
    null

  create_polyline: ->
    if @segments.length > 0
      @polyline = new $G.Polyline @polyline_options()

  polyline_options: ->
    {
      map: @gmap
      path: @polyline_path()
      strokeWeight: 3
      strokeColor: @color
      strokeOpacity: 0.75
      cursor: "default"
      visible: false
      zIndex: @.constructor.get_z_index()
    }

  polyline_path: ->
    @path = []
    for segment in @segments
      @path.push segment.latlng1
    @path.push segment.latlng2
    @path

  bind_polyline: ->
    if @polyline
      $G.event.addListener @polyline, 'mouseover', =>
        @fire_event('mouseover')

      $G.event.addListener @polyline, 'mouseout', =>
        @fire_event('mouseout')
        
  show: ->
    if not @polyline
      @create_polyline()
      @bind_polyline()
    @polyline.setVisible true if @polyline

  hide: ->
    @polyline.setVisible false if @polyline

  highlight: ->
    if @polyline
      @polyline.setOptions strokeWeight: 6, strokeOpacity: 1, zIndex: @.constructor.get_z_index()

  unhighlight: ->
    if @polyline
      @polyline.setOptions strokeWeight: 3, strokeOpacity: 0.75

  destroy: ->
    if @polyline
      @polyline.setMap null
      $G.event.clearInstanceListeners @polyline

  @z_index: 0
  @get_z_index: ->
    ++@z_index

 
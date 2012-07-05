# TODO: Esto debería tener una subclase que maneje cada punto.

class MDC.Directions.Direction.Walk extends Utils.Eventable
  constructor: (@segments, @buses, @gmap)->
    @bus = @buses[0]
    @color = @bus.color
    @calculate_values()

  construct_elements: ->
    @build_buses_icons()
    @bind_buses_icons()
    @build_lines()

  calculate_values: ->
    @distance  = 0
    @distances = []
    for segment in @segments
      distance = segment.distance_in_meters()
      @distance += distance
      @distances.push parseInt(distance)
    @distance = parseInt(distance)

    null

  build_buses_icons: ->
    @buses_icons = []
    for segment in @segments
      @buses_icons.push new MDC.Directions.Direction.WalkBusIcon(segment.middle_latlng(), @buses, @gmap)
    null

  bind_buses_icons: ->
    for bus_icon in @buses_icons
      @inherit_listener bus_icon, 'mouseover'
      @inherit_listener bus_icon, 'mouseout'
    null

  build_lines: ->
    @lines = []
    for segment in @segments
      @lines.push new MDC.Directions.Direction.WalkLine(segment, @color, @gmap)

  show: ->
    @construct_elements() if not @lines
    line.show()     for line in @lines
    bus_icon.show() for bus_icon in @buses_icons
    null

  hide: ->
    if @lines
      line.hide()     for line in @lines
      bus_icon.hide() for bus_icon in @buses_icons
    null

  destroy: ->
    if @lines
      line.destroy()     for line in @lines
      bus_icon.destroy() for bus_icon in @buses_icons
    null
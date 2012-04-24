class window.PathFinder
  constructor: (map, buses)->
    @map     = map
    @buses   = buses

    @checkpoints = []
    @buses_paths = []

    @create_filter_interface()
    @bind_map_events()

  create_filter_interface: ->
    @filter_interface = new PathFilterInterface
    @filter_instructions = new PathFilterInstructions

  bind_map_events: ->
    google.maps.event.addListener @map.gmap, "click", (event)=>
      point = event.latLng
      @add_checkpoint(point)

  add_checkpoint: (point)->
    if @checkpoints.length >= Settings.max_path_finder_checkpoints
      @checkpoints[0].remove_without_callback()
      @after_remove_checkpoint_cleanup(@checkpoints[0])
      
    checkpoint = new PathFinderCheckpoint(@map, point, @checkpoints.length+1, @filter_interface.create_element())
    @checkpoints.push checkpoint
    @bind_checkpoint(checkpoint)
    @calculate_buses()

  bind_checkpoint: (checkpoint)->
    checkpoint.add_listener 'changed', => @calculate_buses()
    checkpoint.add_listener 'removed', (checkpoint)=>
      @after_remove_checkpoint(checkpoint)
    
  set_checkpoints_numbers: ->
    for i, checkpoint of @checkpoints
      checkpoint.set_number(parseInt(i)+1)

  after_remove_checkpoint_cleanup: (checkpoint)->
    @checkpoints.splice @checkpoints.indexOf(checkpoint), 1
    @set_checkpoints_numbers()

  after_remove_checkpoint: (checkpoint)->
    @after_remove_checkpoint_cleanup(checkpoint)
    @calculate_buses()

  calculate_buses: ->
    if @checkpoints.length > 0
      points = (checkpoint.point for checkpoint in @checkpoints)

      buses_paths = []
      for bus in @buses
        bus_paths = bus.paths_to_checkpoints(points)
        buses_paths.push bus_paths

      ordered_buses_paths = buses_paths.sort (bus_paths_a, bus_paths_b)->
        bus_paths_a.total_distance - bus_paths_b.total_distance

      buses_paths_to_display = ordered_buses_paths[0..(Settings.max_buses_suggestions-1)]
      buses_paths_to_hide    = ordered_buses_paths[Settings.max_buses_suggestions..]

      bus_paths.bus.activate() for bus_paths in buses_paths_to_display
      bus_paths.bus.deactivate() for bus_paths in buses_paths_to_hide

      @display_buses_paths_lines(buses_paths_to_display)
    else
      @hide_buses_paths()


  # This function create new paths or recycle the existant.
  display_buses_paths_lines: (buses_paths)->
    @hide_buses_paths()
    count = 0
    for bus_paths in buses_paths
      for segment in bus_paths.paths
        if @buses_paths[count]
          @buses_paths[count].update(bus_paths.bus, segment)
        else
          @buses_paths.push new BusPath(bus_paths.bus, segment, @map.gmap)
        ++count

    for bus_path in @buses_paths[count..]
      bus_path.hide()

  hide_buses_paths: ->
    for bus_path in @buses_paths
      bus_path.hide()

class window.BusPath
  constructor: (bus, segment, gmap)->
    @gmap = gmap
    @segment = segment
    @bus = bus
    @create_polyline()
    @create_marker()
    @bind_marker()

  create_polyline: ->
    @poly = new $G.Polyline @polyline_options()

  polyline_options: ->
    {
      strokeWeight: 1,
      strokeColor: 'red',
      strokeOpacity: 1,
      clickable: false,
      path: @segment.path(),
      map: @gmap
    }

  create_marker: ->
    @marker = new $G.Marker @marker_options()

  marker_options: ->
    {
      map: @gmap,
      position: $LatLng(@segment.middle_point()),
      icon: @bus.marker_image(),
      zIndex: 9999
    }

  bind_marker: ->
    $G.event.clearInstanceListeners(@marker)
    $G.event.addListener @marker, 'mouseover', => @bus.highlight_routes()
    $G.event.addListener @marker, 'mouseout', => @bus.unhighlight_routes()

  update_polyline: ->
    @poly.setPath @segment.path()

  update_marker: (bus)->
    if bus != @bus
      @marker.setIcon(@bus.marker_image())
    @marker.setPosition($LatLng @segment.middle_point())
    @bind_marker()

  update: (bus, segment)->
    [@bus, bus] = [bus, @bus]
    @segment = segment
    @update_polyline()
    @update_marker(bus)

    @show()

  hide: ->
    @poly.setVisible false
    @marker.setVisible false
  show: ->
    @poly.setVisible true
    @marker.setVisible true

    
    
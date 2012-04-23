class window.PathFinder
  constructor: (map, buses)->
    @map     = map
    @buses   = buses
    
    @circles = []

    @create_filter_interface()
    @bind_map_events()

  create_filter_interface: ->
    @filter_interface = new PathFilterInterface
    @filter_instructions = new PathFilterInstructions

  bind_map_events: ->
    google.maps.event.addListener @map.gmap, "click", (event)=>
      point = event.latLng
      @add_circle(point)

  add_circle: (point)->
    @filter_instructions.fire_auto_hide('start')
    @filter_instructions.fire('many_zones')
    @filter_instructions.fire('remove')

    if @circles.length >= Settings.max_path_finder_circles
      @circles[0].remove()
      @clean_up_circle(@circles[0], false)
      @filter_instructions.fire('maximum')

    circle = @create_circle(point)
    @circles.push(circle)
    @bind_circle(circle)
    @calculate_buses()

  create_circle: (point)->
    circle = new PathFinderCircle(@map, 
                                  point,
                                  Settings.default_path_finders_meters,
                                  @circles.length+1,
                                  @filter_interface.create_element())

  bind_circle: (circle)->
    circle.add_listener 'changed', => @calculate_buses()
    circle.add_listener 'deleted', => @clean_up_circle(circle)



  clean_up_circle: (circle, recalculate = true)->
    @circles.splice @circles.indexOf(circle), 1
    for i, circle of @circles
      circle.set_number(parseInt(i)+1)
    @previous_buses = false
    @calculate_buses() if recalculate


  hide_circles_suggestions: ->
    for circle in @circles
      circle.hide_suggestion()

  calculate_buses: ->
    if @circles.length > 0
      buses_matches = []
      found_buses = []

      @hide_circles_suggestions()

      for bus in @buses
        bus_match = bus.pass_through_circles(@circles)
        buses_matches.push bus_match
        if bus_match.matches()
          found_buses.push bus
          bus.activate()
        else
          bus.deactivate()

      if found_buses.length == 0
        @calculate_suggestions(buses_matches)

    else
      @filter_instructions.show('start')


  calculate_suggestions: (buses_matches)->
    filtered_matches = _.filter buses_matches, (bus_match)->
      bus_match.total_distance_left() < Settings.max_path_finder_suggestion_extra_meters

    ordered_matches = filtered_matches.sort (bus_match_a, bus_match_b)->
      bus_match_a.total_distance_left() - bus_match_b.total_distance_left()

    suggestions_distances = []
    if ordered_matches
      @filter_instructions.fire('suggestion')
      for bus_match in ordered_matches
        bus_match.bus.activate()
        for i, distance of bus_match.distances_left
          if distance > 0
            if not suggestions_distances[i] or suggestions_distances[i] < distance
              suggestions_distances[i] = distance


      for i, circle of @circles
        if suggestions_distances[i]
          circle.show_suggestion(circle.radius + suggestions_distances[i])
    else
      @filter_instructions.fire('no_buses')
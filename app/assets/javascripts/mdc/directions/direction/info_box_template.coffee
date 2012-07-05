class MDC.Directions.Direction.InfoBoxTemplate
  constructor: ->
    @find_elements()
    @parse_elements()

  find_elements: ->
    @element             = $$("bus-direction-template")
    @bus_name            = @element.find('.bus-name-value')
    @walk_distance       = @element.find('.walking-distance')
    @route_distance      = @element.find('.route-distance')

  parse_elements: ->
    @element.removeAttr('id')
    @element.remove()

    @walk_distance_unit  = 'm'
    @route_distance_unit = 'km'

    @walk_title_start  = @walk_distance.attr('data-title-start')
    @walk_title_middle = @walk_distance.attr('data-title-middle')
    @walk_title_end    = @walk_distance.attr('data-title-end')

  generate_walk_distances: (walk_distances)->
    last = walk_distances.length-1
    for walk_distance, i in walk_distances
      if i == 0
        @generate_walk_distance(walk_distance, @walk_title_start)
      else if i == last
        @generate_walk_distance(walk_distance, @walk_title_middle)
      else
        @generate_walk_distance(walk_distance, @walk_title_end)

      
  generate_walk_distance: (value, title)->
    "<span title='#{title}'>#{value}#{@walk_distance_unit}</span>"

  set_values: (buses_names, walk_distances, route_distance)->
    route_distance = parseInt(route_distance / 1000)
    walk_distances = @generate_walk_distances walk_distances

    @bus_name[0].innerHTML = buses_names.join('/')
    @walk_distance[0].innerHTML = walk_distances.join('/')
    @route_distance[0].innerHTML = route_distance + @route_distance_unit

  clone: (buses_names, walk_distances, route_distance)->
    @set_values(buses_names, walk_distances, route_distance)
    @element.clone()


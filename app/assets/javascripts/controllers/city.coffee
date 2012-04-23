class window.City
  buses: []

  constructor: (data)->
    @data = data
    @find_element()
    
    @build_map()
    @build_bus_groups()
    @build_path_finder()
    @build_buses_url_rewriter()

  find_element: ->
    @element = @e = $$('map')

  build_map: ->
    @map = new Map(@element, @data.viewport)

  build_bus_groups: ->
    @bus_groups = for bus_group in @data.bus_groups
      bus_group = new BusGroup bus_group, this
      @buses = @buses.concat bus_group.buses
      bus_group

  build_path_finder: ->
    @path_finder = new PathFinder(@map, @buses)

  build_buses_url_rewriter: ->
    @buses_url_rewriter = new BusesUrlRewrite(@buses)

    


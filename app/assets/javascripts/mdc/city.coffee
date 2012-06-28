class MDC.City
  buses: []

  constructor: (data)->
    #@data = data # (Don't save all the data in a variable, better for obfuscation...)
    @find_element()
    
    @build_map(data)
    @build_help_bar()
    @build_bus_groups(data)
    @build_directions_manager()
    @build_sell_locations_manager(data["visible_sell_locations"])
    @build_url_rewriter()
    @build_bus_info()


  find_element: ->
    @element = @e = $$('map')

  build_map: (data)->
    @map = new MapTools.Map(@element, data["viewport"])

  build_help_bar: ->
    @help_bar = new MDC.Interface.HelpBar

  build_bus_groups: (data)->
    @bus_groups = for bus_group in data["bus_groups"]
      bus_group = new MDC.BusGroup bus_group, this
      @buses = @buses.concat bus_group.buses
      bus_group


  build_directions_manager: ->
    @directions_manager = new MDC.Directions.Manager(@map, @buses)

  build_sell_locations_manager: (sell_locations_data)->
    @sell_locations_manager = new MDC.SellLocations.Manager(sell_locations_data, @map)

  build_url_rewriter: ->
    @buses_url_rewriter = new MDC.Interface.UrlRewriter(@buses, @sell_locations_manager)

  build_bus_info: ->
    @bus_info = new MDC.Interface.BusInfo()